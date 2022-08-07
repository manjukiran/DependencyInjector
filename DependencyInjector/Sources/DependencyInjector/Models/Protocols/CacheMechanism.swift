//
//  CacheMechanism.swift
//  DependencyInjector
//
//  Created by Manju Kiran on 06/08/2022.
//

internal protocol CacheMechanism {
    var instance: Any? { get set }
    func getInstance() -> Any?
    func setInstance(_ instance: Any)
}
