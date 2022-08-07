//
//  ServiceAttributes.swift
//  DependencyInjector
//
//  Created by Manju Kiran on 04/08/2022.
//

internal typealias Block = Any

/// Protocol definition for the attributes used to help register a constructor & create a hashable key
internal protocol ServiceAttributesProtocol {
    
    /// Type of Scope for creation of instance
    var scope: ObjectScope { get }

    /// Block where the assembler can provide the instance
    var constructor: Block { get }

    /// Callback after instantiation has completed, to help with circular references
    var initCompleted: (Block)? { get }

    /// Type of the protocol/class that is to be registered
    var serviceType: Any.Type { get }
    
    /// Storage mechanism for instances that need to be cached
    var storage: CacheMechanism? { get}
}
