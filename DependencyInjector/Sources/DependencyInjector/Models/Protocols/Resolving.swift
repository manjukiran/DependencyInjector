//
//  Resolving.swift
//  DependencyInjector
//
//  Created by Manju Kiran on 04/08/2022.
//

public protocol Resolving {
    /// Resolves and retuuns the instance of the registered protocol
    /// - Parameters:
    ///   - _: Type of class/protocol to resolve
    ///   - identifier: Additional identifier if the original registration was carried out with the identifier (to allow multiple classes to be registered for the same `Service.type`
    /// - Returns: Instance of the protocol what was registered
    func resolve<Service>(_: Service.Type, identifier: String?) -> Service?
}

public extension Resolving {
    
    func resolve<Service>(_: Service.Type) -> Service? {
        resolve(Service.self, identifier: nil)
    }
}

public protocol ResolvingDelegate: AnyObject {
    
    /// Delegate call back to log the failure of resolution
    /// - Parameters:
    ///   - resolving: Resolver reference to follow up with further actions
    ///   - key: Service key for the failed resolution
    func resolverFailedToResolve<Service>(resolving: Resolving, for type: Service.Type, with identifier: String?)
    
}
