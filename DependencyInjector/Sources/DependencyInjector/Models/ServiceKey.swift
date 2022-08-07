//
//  ServiceKey.swift
//  DependencyInjector
//
//  Created by Manju Kiran on 04/08/2022.
//

/// Hashable struct to create keys for storing references in the container
internal struct ServiceKey {
    /// Protocol/Class type for identification
    let type: Any.Type
    /// Additional key to register multiple instances of the same `type`
    let identifier: String?
    
    init(type: Any.Type,
         identifier: String? = nil) {
        self.type = type
        self.identifier = identifier
    }
}

extension ServiceKey: Hashable {
    
    public static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        lhs.type == rhs.type
        && lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(type).hash(into: &hasher)
        identifier?.hash(into: &hasher)
    }
}
