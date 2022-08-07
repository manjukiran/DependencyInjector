//
//  ServiceAttributes.swift
//  DependencyInjector
//
//  Created by Manju Kiran on 04/08/2022.
//

/// Class to define
public final class ServiceAttributes<Service>: ServiceAttributesProtocol {
    
    public let serviceType: Any.Type
    public private(set) var scope: ObjectScope
    public let constructor: (Any)
    
    fileprivate var initCompletedAction: ((Resolving, Service) -> Void)?
    
    internal var initCompleted: Block? {
        guard let action = initCompletedAction else { return nil }        
        return { (resolver: Resolving, service: Service) -> Void in
            action(resolver, service)
        }
    }
    
    internal lazy var storage: CacheMechanism? = {
        self.scope.storageMechanism
    }()
    
    init(serviceType: Service.Type,
         scope: ObjectScope = .graph,
         constructor: (Any)) {
        self.scope = scope
        self.constructor = constructor
        self.serviceType = serviceType
    }
    
    @discardableResult
    /// Function to set the `initCompleted` block post construction so that all resolutions can be resolved for circular dependencies
    /// - Parameter completed: handler post completion
    /// - Returns: `Self` instance of the attribute for further processing
    public func initCompleted(_ completed: @escaping (Resolving, Service) -> Void) -> Self {
        initCompletedAction = completed
        return self
    }

    @discardableResult
    /// Function to set the `object scope` to help with storage mechanism
    /// - Parameter scope: <#scope description#>
    /// - Returns: `Self` instance of the attribute for further processing
    public func setScope(_ scope: ObjectScope) -> Self {
        self.scope = scope
        return self
    }
    
    
}


