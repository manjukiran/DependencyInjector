//
//  Containing.swift
//  DependencyInjector
//
//  Created by Manju Kiran on 04/08/2022.
//

internal protocol Containing {
    
    /// Registers the protocol type `Service` with a handler for constructing the instance
    /// - Parameters:
    ///   - type: Protocol/Class type
    ///   - constructor: Constructor block where the instance is to be returned within
    ///   - identifier: Additional identifier to help register multiple constructors/classes for the same protocol
    /// - Returns: Instance of service attributes that includes a post-init handler for circularity handling
    func register<Service>(type: Service.Type,
                           identifier: String?,
                           constructor: @escaping (Resolving) -> Service) -> ServiceAttributes<Service>
}
