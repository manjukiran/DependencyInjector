//
//  ContainerTests.swift
//  
//
//  Created by Manju Kiran on 04/08/2022.
//

import XCTest
@testable import DependencyInjector

class ContainerTests: XCTestCase {
    var sut: Container!
    
    override func setUpWithError() throws {
        sut = Container()
    }
    
    override func tearDownWithError() throws {
        sut.clear()
        try super.tearDownWithError()
    }
    
    
    /// Nothing is registered
    func testContainer_ReturnsNil_When_Nothing_IsRegisteredForProtocol() {
        // Given
        let worker = sut.resolve(DataRetrieving.self)
        // Then
        XCTAssertNil(worker)
    }
    
    /// One Service is registered for the protocol
    func testContainer_ReturnsInstance_Without_Identifier() {
        // Given
        sut.register(type: DataRetrieving.self) { _ in  CachedDataRetriever() }
        
        // When
        let cachedDataRetriever = sut.resolve(DataRetrieving.self)
        
        // Then
        XCTAssertTrue(cachedDataRetriever is CachedDataRetriever)
        XCTAssertEqual(cachedDataRetriever?.type, .cache)
    }
    
    func testContainer_ReturnsInstance_With_Identifier() throws {
        // Given
        sut.register(type: DataRetrieving.self, identifier: "LocalData") { _ in  LocalDataRetriever() }

        // When
        let unregisteredService = sut.resolve(DataRetrieving.self)
        
        // Then
        let cachedDataRetriever = try XCTUnwrap(sut.resolve(DataRetrieving.self, identifier: "LocalData"))
        
        XCTAssertNil(unregisteredService)
        XCTAssertNotNil(cachedDataRetriever)
        
        XCTAssertTrue(cachedDataRetriever is LocalDataRetriever)
        XCTAssertEqual(cachedDataRetriever.type, .local)
    }
    
    
    /// Multiple Services Registered under different identifiers
    func testContainer_Returns_MultipleInstances_With_Identifier() throws {
        // Given
        sut.register(type: DataRetrieving.self, identifier: "LocalData") { _ in  LocalDataRetriever() }
        sut.register(type: DataRetrieving.self, identifier: "CachedData") { _ in CachedDataRetriever() }
        
        // When
        let localDataRetriever = try XCTUnwrap(sut.resolve(DataRetrieving.self, identifier: "LocalData") as? LocalDataRetriever)
        let cachedDataRetriever = try XCTUnwrap(sut.resolve(DataRetrieving.self, identifier: "CachedData") as? CachedDataRetriever)
        
        // Then
        XCTAssertEqual(localDataRetriever.type, .local)
        XCTAssertEqual(cachedDataRetriever.type, .cache)
    }
    
    /// Clear out all registered services
    func testContainer_Clears_AllInstances_With_Clear() throws {
        // Given
        sut.register(type: DataRetrieving.self, identifier: "LocalData") { _ in  LocalDataRetriever() }
        sut.register(type: DataRetrieving.self, identifier: "CachedData") { _ in CachedDataRetriever() }
        
        // Precondition
        XCTAssertNil(sut.resolve(DataRetrieving.self))
        let _ = try XCTUnwrap(sut.resolve(DataRetrieving.self, identifier: "LocalData") as? LocalDataRetriever)
        let _ = try XCTUnwrap(sut.resolve(DataRetrieving.self, identifier: "CachedData") as? CachedDataRetriever)
        
        // When
        sut.clear()
        
        // Then
        XCTAssertNil(sut.resolve(DataRetrieving.self))
        XCTAssertNil(sut.resolve(DataRetrieving.self, identifier: "LocalData"))
        XCTAssertNil(sut.resolve(DataRetrieving.self, identifier: "CachedData"))
    }
    
    func testContainer_Clears_OnlySpecific_Instances_With_Clear() throws {
        
        // Given
        sut.register(type: DataRetrieving.self, identifier: "LocalData") { _ in  LocalDataRetriever() }
        sut.register(type: DataRetrieving.self, identifier: "CachedData") { _ in CachedDataRetriever() }
        
        // Precondition
        let _ = try XCTUnwrap(sut.resolve(DataRetrieving.self, identifier: "LocalData") as? LocalDataRetriever)
        let _ = try XCTUnwrap(sut.resolve(DataRetrieving.self, identifier: "CachedData") as? CachedDataRetriever)
        
        // When
        sut.clear(type: DataRetrieving.self, identifier: "LocalData")
        
        // Then
        
        // Should be nil
        XCTAssertNil(sut.resolve(DataRetrieving.self, identifier: "LocalData"))
        
        // Should NOT be nil
        XCTAssertNotNil(sut.resolve(DataRetrieving.self, identifier: "CachedData"))
    }
    
    func testContainer_Resolves_ToSet_Dependencies() throws {
        
        // Given
        sut.register(type: DataRetrieving.self, identifier: "CachedData") { _ in  CachedDataRetriever() }
        
        sut.register(type: DataRetrieving.self) { resolver in
            let cachedDataRetriever = resolver.resolve(DataRetrieving.self, identifier: "CachedData") as! CachedDataRetriever
            let networkDataRetriever = NetworkDataRetriever(cachedDataRetriever: cachedDataRetriever)
            return networkDataRetriever
        }
        
        // When
        let networkDataRetriever = try XCTUnwrap(sut.resolve(DataRetrieving.self) as? NetworkDataRetriever)
        
        // Then
        XCTAssertNotNil(networkDataRetriever.cachedDataRetriever)
    }
    
    // MARK: Circular Dependencies
    
    func testContainer_Calls_InitCompleted_UponResolution() throws {
        
        // Given
        sut.register(type: ParentType.self) {
            _ in Parent()
        }.initCompleted { resolver, resolved in
            let parent = resolved as! Parent
            parent.children = [resolver.resolve(ChildType.self) as? Child].compactMap { $0 }
        }.setScope(.container)
        
        do {
            // Circular References
            sut.register(type: ChildType.self) { _ in
                Child(name: "Child 1")
            }.initCompleted { resolver, resolved in
                let child = resolved as! Child
                let parent = resolver.resolve(ParentType.self) as! Parent
                child.parent = parent
            }.setScope(.container)
            // When
            let child = try XCTUnwrap(sut.resolve(ChildType.self) as? Child)
            
            // Then
            XCTAssertEqual(child.name, "Child 1")
            XCTAssertNotNil(child.parent)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
}
