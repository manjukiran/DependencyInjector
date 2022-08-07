//
//  ContainerStorageTests.swift
//  DependencyInjectorTests
//
//  Created by Manju Kiran on 07/08/2022.
//

import XCTest
@testable import DependencyInjector

class ContainerStorageTests: XCTestCase {
    
    var sut: ContainerStorage!
    
    override func setUpWithError() throws {
        sut = ContainerStorage()
    }
    
    func test_setInstance_returns_expectedInstance() throws {
        
        let variable = "Some String"
        
        // Pre-condition
        XCTAssertNil(sut.instance)
        
        // When
        sut.setInstance(variable)
        
        // Then
        XCTAssertEqual(try XCTUnwrap(sut.getInstance() as? String), variable)
    }
}
