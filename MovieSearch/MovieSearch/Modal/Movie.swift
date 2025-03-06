//
//  Movie.swift
//  MovieSearch
//
//  Created by chiam shwuyeh on 2025-03-05.
//

import Foundation
import ObjectMapper
import BetterCodable
import Vapor

public struct MovieDO: Content, Hashable {
    public var search = [MovieList]()
    public var response = String()
    public var totalResults = String()
    
    public init() {}
    public init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case response = "Response"
        case totalResults = "totalResults"
    }
}

public struct MovieList: Content, Hashable {
    public var title: String?
    public var year: String?
    public var imdbID: String?
    public var type: String?
    public var poster: String?
    
    public init() {}
    public init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
