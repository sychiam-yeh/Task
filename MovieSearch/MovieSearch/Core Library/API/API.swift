//
//  API.swift
//  MovieSearch
//
//  Created by chiam shwuyeh on 2025-03-04.
//

import Foundation
import Alamofire
import Combine

class API {
    
    /* =================================================================
     *                   MARK: - Local Initialization
     * ================================================================== */
    static let alamofireManager: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 60
        let mgr = Alamofire.Session(configuration: config)
        
        return mgr
    }()
    
    static var decoder: JSONDecoder {
        get {
            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }
    }
    
    static func generateError(statusCode: Int, errorMessage: String) -> NetworkCallError {
        switch statusCode {
        case 400:
            return .badRequest(errorMessage)
        case 401:
            return .authenticationError(errorMessage)
        case 403:
            return .serverIsUnreachable
        case 404:
            return .pageNotFound
        case 500:
            return .internalServerError(errorMessage)
        case 502:
            return .badGateway
        default:
            return .genericError(errorMessage)
        }
    }
    
    /* =================================================================
     *                   MARK: - Class Function
     * ================================================================== */
    static func setEndpoint(url site: String,
                            type: APIType = .default,
                            queryItems: [URLQueryItem]? = nil) -> URLComponents {
        var components = URLComponents()
        components.scheme = URLComponent.baseProtocol.rawValue
        
        switch type {
        case .default:
            components.scheme = "https"
            components.host = URLComponent.baseUrl.rawValue
            components.path = "/\(site)"
        }
        if let queryItemsArray = queryItems {
            components.queryItems = [URLQueryItem]()
            for eachQueryItem in queryItemsArray {
                components.queryItems?.append(eachQueryItem)
            }
        }
       
        return components
    }
  
    static func initiateGETSingleObjectWithoutWrapper<T: Codable>(module: Module, typeOf: T) -> AnyPublisher<T, NetworkCallError> {
        return self.alamofireManager.request(module.URLRequest,
                                             method: .get,
                                             encoding: JSONEncoding.default)
        .publishDecodable(type: T.self, decoder: decoder)
        .tryMap({ response in
            switch response.result {
            case .success(_):
                if let data = response.value, let HTTPResponse = response.response {
                    let statusCode = HTTPResponse.statusCode
                    if (200...299).contains(statusCode) {
                        return data
                    }
                    else {
                        throw self.generateError(statusCode: statusCode, errorMessage: "Error with status code: \(statusCode)")
                    }
                }
            case .failure(let error):
                throw error
            }
            throw NetworkCallError.genericError("Empty Response")
        })
        .mapError({ error in
            switch error {
            case let afError as AFError:
                return NetworkCallError.alamofire(afError)
            default:
                return NetworkCallError.genericError(error.localizedDescription)
            }
        })
        .eraseToAnyPublisher()
    }
}
