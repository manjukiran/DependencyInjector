//
//  CircularReferenceMocks.swift
//  
//
//  Created by Manju Kiran on 06/08/2022.
//

/// This is the same file as that of the mocked file in the `DependencyInjector` mocks folder

internal protocol ParentType: AnyObject {
    var children: [ChildType] { get set }
}

protocol ChildType {
    var parent: ParentType? { get set }
    var name: String { get }
}

class Parent: ParentType {
    var children: [ChildType]
    
    init(children: [ChildType] = []) {
        self.children = children
    }
}

class Child: ChildType {

    weak var parent: ParentType? 
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
