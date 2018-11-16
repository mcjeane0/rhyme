//
//  DataMuseRequestFactory.swift
//  rhyme
//
//  Created by Arjun Iyer on 11/15/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation


struct DataMuseRequestFactory {
    
    
    static let dataMuseBaseURLString = "api.datamuse.com"
    
    static let exactRhymesFormat = "/words?/rel_rhy="
    
    static let approximateRhymesFormat = "/words?/rel_nry="
    
    static func createExactRhymesRequest(_ string:String)->URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = DataMuseRequestFactory.dataMuseBaseURLString
        urlComponents.path = "\(exactRhymesFormat)\(string)"
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
    
    static func createApproximateRhymesRequest(_ string:String)->URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = DataMuseRequestFactory.dataMuseBaseURLString
        urlComponents.path = "\(approximateRhymesFormat)\(string)"
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
    
    
}
