//
//  SearchResultTracks.swift
//  YM-API
//
//  Created by Developer on 15.07.2021.
//

///Search results (tracks)
public class SearchResultTracks: Decodable {
    ///Type of item
    public let type: String?
    ///Result items total count
    public let total: Int
    ///Count of results at one page
    public let perPage: Int
    ///Block position
    public let order: Int
    ///Best result data object
    public let results: [Track]
    
    public init(type: String?, total: Int, perPage: Int, order: Int, results: [Track]) {
        self.type = type
        self.total = total
        self.perPage = perPage
        self.order = order
        self.results = results
    }
}
