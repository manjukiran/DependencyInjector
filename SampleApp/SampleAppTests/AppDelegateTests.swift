//
//  AppDelegateTests.swift
//  SampleAppTests
//
//  Created by Manju Kiran on 07/08/2022.
//

import XCTest
@testable import SampleApp

class AppDelegateTests: XCTestCase {
    
    func testAppDelegate_HasRegistered_ParentProtocol() throws {
        // All other mechanisms have been tested in the Library
        
        let appDelegate = try XCTUnwrap(UIApplication.shared.delegate as? AppDelegate)
        let resolvedInstance = appDelegate.container.resolve(ParentType.self)
        XCTAssertNotNil(resolvedInstance)
        XCTAssertTrue(resolvedInstance is Parent)
        
    }
    
}
