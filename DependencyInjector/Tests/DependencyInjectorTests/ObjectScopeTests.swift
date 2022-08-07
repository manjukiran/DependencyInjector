//
//  ObjectScopeTests.swift
//  DependencyInjectorTests
//
//  Created by Manju Kiran on 07/08/2022.
//

import XCTest
@testable import DependencyInjector

class ObjectScopeTests: XCTestCase {
    
    func testStorageMechanisms_ForObjectScope() throws {
        try ObjectScope.allCases.forEach { scope in
            switch scope {
            case .transient, .graph:
                XCTAssertNil(scope.storageMechanism)
            case .container:
                let _ = try XCTUnwrap(scope.storageMechanism as? ContainerStorage)
            }
        }
    }
}
