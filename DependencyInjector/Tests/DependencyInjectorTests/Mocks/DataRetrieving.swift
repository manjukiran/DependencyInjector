//
//  DataRetrieving.swift
//  
//
//  Created by Manju Kiran on 04/08/2022.
//
import Foundation

internal enum DataRetrievingType: String {
    case network
    case cache
    case local
}

internal protocol DataRetrieving {
    
    var type: DataRetrievingType { get }

    func getData<T>(url: URL, completion: @escaping ((Result<T,Error>) -> Void))
}

internal class NetworkDataRetriever: DataRetrieving {
    
    let type: DataRetrievingType = .network
    
    let cachedDataRetriever: CachedDataRetriever
    
    init(cachedDataRetriever: CachedDataRetriever) {
        self.cachedDataRetriever = cachedDataRetriever
    }
    
    func getData<T>(url: URL, completion: @escaping ((Result<T, Error>) -> Void)) {
        let handler: ((Result<T, Error>) -> Void) = { [weak self] result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                self?.retrieveData(url: url, completion: completion)
            }
        }
        
        cachedDataRetriever.getData(url: url, completion: handler)
    }
    
    private func retrieveData<T>(url: URL, completion: @escaping ((Result<T, Error>) -> Void)) {
        // Do Nothing
        // Out of scope for the test
    }
}

internal class CachedDataRetriever: DataRetrieving {

    let type: DataRetrievingType = .cache

    func getData<T>(url: URL, completion: @escaping ((Result<T, Error>) -> Void)) {
        // Do Nothing
        // Out of scope for the test
    }

}

internal class LocalDataRetriever: DataRetrieving {

    let type: DataRetrievingType = .local

    func getData<T>(url: URL, completion: @escaping ((Result<T, Error>) -> Void)) {
        // Do Nothing
        // Out of scope for the test
    }

}
