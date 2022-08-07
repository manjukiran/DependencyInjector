//
//  Container.swift
//  DependencyInjector
//
//  Created by Manju Kiran on 04/08/2022.
//

/// Primary Cont

public final class Container {
    /// Delegate to report failure of resolution
    public weak var delegate: ResolvingDelegate?
    private var dependencies = [ServiceKey: ServiceAttributesProtocol]()
    
    public init() {}
}

extension Container: Containing {
    
    @discardableResult
    public func register<Service>(type: Service.Type,
                                  identifier: String? = nil,
                                  constructor: @escaping (Resolving) -> Service) -> ServiceAttributes<Service> {
        let key = ServiceKey(type: Service.self, identifier: identifier)
        let value = ServiceAttributes(serviceType: type, constructor: constructor)
        dependencies[key] = value
        return value
    }

    /// Clears all registrations of the container
    public func clear() {
        dependencies.removeAll()
    }

    /// Clears the registration for a single Service.type & Identifier.
    /// - Parameters:
    ///   - type: Protocol/Class type
    ///   - identifier: Additional identifier to help register multiple constructors/classes for the same protocol
    public func clear<Service>(type: Service.Type, identifier: String? = nil) {
        let key = ServiceKey(type: Service.self, identifier: identifier)
        dependencies.removeValue(forKey: key)
    }
    
}

extension Container: Resolving {
    
    public func resolve<Service>(_: Service.Type, identifier: String? = nil) -> Service? {
        return _resolve(identifier: identifier) { (constructor: (Resolving) -> Service) in constructor(self) }
    }
}

private extension Container {
    
    /// Private function to help with resolution of the service key
    /// - Parameters:
    ///   - identifier: Additional key to register multiple instances of the same `type`
    ///   - invoker: Nested handler that returns the Service. The internal handler calls the original constructor block to return the service while invoking the `initCompleted` block
    /// - Returns: Resolved instance of the `Service.type` that was specified for the `identifier`
    private func _resolve<Service>(identifier: String?, invoker: @escaping ((Resolving) -> Service) -> Service) -> Service? {
        var resolvedInstance: Service?
        let key = ServiceKey(type: Service.self, identifier: identifier)
        
        if let value = dependencies[key] {
            resolvedInstance = resolve(entry: value, invoker: invoker)
        }
        
        if resolvedInstance == nil {
            let resolvedName = identifier ?? ""
            let message = """
                          Dependency for \(String(describing: Service.self)) "
                          \(resolvedName.isEmpty  ? "" : "with \(resolvedName) ")
                          is not set. Please Investigate
                          """
            debugPrint(message)
            delegate?.resolverFailedToResolve(resolving: self, for: Service.self, with: identifier)
        }
        return resolvedInstance
    }
    
    /// Private function to help with resolution of the service key
    /// - Parameters:
    ///   - entry: Resolved instance of the `Service.type` with `identifier`
    ///   - invoker: handler that upon invoking calls the original constructor block to return the service and also invokes the `initCompleted` block within
    /// - Returns: Resolved instance of the `Service.type` that was specified for the `identifier`
    private func resolve<Service, Constructor>(entry: ServiceAttributesProtocol,
                                               invoker: @escaping (Constructor) -> Service) -> Service? {
        let resolution: () -> Service? = { [self] in
            
            if let cachedInstance: Service = cachedInstance(entry) {
                return cachedInstance
            }
            
            let resolvedInstance = invoker(entry.constructor as! Constructor)
            entry.storage?.setInstance(resolvedInstance)
            
            // Call `initCompleted` for any circular dependencies
            if let completed = entry.initCompleted as? (Resolving, Service) -> Void {
                completed(self, resolvedInstance)
            }

            return resolvedInstance
        }
        return resolution()
    }
    
    private func cachedInstance<Service>(_ entry: ServiceAttributesProtocol) -> Service? {
        guard let cachedInstance =  entry.storage?.instance as? Service else {
            return nil
        }
        return cachedInstance
    }
    
}
