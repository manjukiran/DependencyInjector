DependencyInjector
========

### Background
This is a simple dependency injection framework created for Swift.

_Dependency injection (DI) is a software design pattern that implements Inversion of Control (IoC) for resolving dependencies._

### Current Solution

Being a DI framework, the basic usage of the library is currently that of registering and accessing services. This is supported via transient and container scopes. 

### Usage

* After adding `import DependencyInjector` to your class, `Containers` can be accessed with a simple  ``` let container = Container()``` 

* From here, register a protocol and service by

```swift
container.register(type: Protocol.self) { _ in  ConcreteProtocolClass() }
```

* To access a service previously registered

```swift
let class = container.resolve(Protocol)
```

* The framework adds ability to register & accessing multiple services for the same protocol by the use of an identifier string

```swift
/// Register
container.register(type: DataRetrieving.self, identifier: "LocalData") { _ in  
	LocalDataRetriever() 
}
container.register(type: DataRetrieving.self, identifier: "CachedData") { _ in 
	CachedDataRetriever() 
}

/// Access
let localDataRetriever = container.resolve(DataRetrieving.self, identifier: "LocalData") as? LocalDataRetriever
let cachedDataRetriever = container.resolve(DataRetrieving.self, identifier: "CachedData") as? CachedDataRetriever

```


## Credits

The DI container features of DependencyInjector are heaily inspired by [Swinject](https://github.com/Swinject/Swinject), as I acknowledge my complete original lack of awareness around such frameworks and the usage. 

The past two days of trying to simplify and understand the concepts have been humbling and a lot of fun.


#### UI

The solution does not contain any UI Implementation as there are no requirments for this support any UI requirements. 


#### UnitTests

The code also contains 100% test coverage. 
