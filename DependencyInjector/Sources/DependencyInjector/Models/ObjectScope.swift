//
//  ObjectScope.swift
//  DependencyInjector
//
//  Created by Manju Kiran on 04/08/2022.
//

/// Enum to define the way instances are created/accessed for resolution
public enum ObjectScope: CaseIterable {
    case transient
    case container
    case graph // To be implemented
    
    var storageMechanism: CacheMechanism? {
        switch self {
        case .transient, .graph:
            return nil
        case .container:
            return ContainerStorage()
        }
    }
    
}

internal class ContainerStorage: CacheMechanism {
    
    internal var instance: Any?
    
    func getInstance() -> Any? {
        instance
    }
    
    func setInstance(_ instance: Any) {
        self.instance = instance
    }
    
}
