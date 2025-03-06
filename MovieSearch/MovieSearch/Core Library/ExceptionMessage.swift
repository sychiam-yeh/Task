//
//  ExceptionMessage.swift
//  MovieSearch
//
//  Created by chiam shwuyeh on 2025-03-05.
//


import Foundation
import Alamofire

enum NetworkCallError: Error, LocalizedError {
    case internetNotConnected
    case successful
    case genericError(String)
    case authenticationError(String)
    case badRequest(String)
    case internalServerError(String)
    case pageNotFound
    case serverIsUnreachable
    case cannotFindHost
    case requestTimedOut
    case badGateway
    case alamofire(AFError)
    
    private var responseMessage: String {
        switch self {
        case .internetNotConnected:
            return "Internet is not connected"
        case .successful:
            return "API is called successfully"
        case .genericError(let errorMessage):
            return errorMessage
        case .authenticationError(let errorMessage):
            return "Authentication Error: \(errorMessage)"
        case .badRequest(let errorMessage):
            return "Bad Request: \(errorMessage)"
        case .internalServerError(let errorMessage):
            return "Internal Server Error: \(errorMessage)"
        case .pageNotFound:
            return "Page not found"
        case .serverIsUnreachable:
            return "Server is currently unreachable"
        case .cannotFindHost:
            return "A server with the specified hostname could not be found"
        case .requestTimedOut:
            return "Request Timed Out"
        case .badGateway:
            return "Bad Gateway"
        case .alamofire(let error):
            return error.localizedDescription
        }
    }
    public var errorDescription: String? {
        return NSLocalizedString(self.responseMessage, comment: "")
    }
}
