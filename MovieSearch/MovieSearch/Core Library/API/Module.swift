//
//  Module.swift
//  MovieSearch
//
//  Created by chiam shwuyeh on 2025-03-04.
//

import Foundation

extension API {
    enum Module {
        case getMovie(String, String)
        
        var URLRequest: URLComponents {
            switch self {
            case .getMovie(let title, let apiKey):
                let queryItems = [URLQueryItem(name: "s", value: title), URLQueryItem(name: "apikey", value: apiKey)]
                return API.setEndpoint(url: "", type: .default, queryItems: queryItems)
            }
        }
    }
}
