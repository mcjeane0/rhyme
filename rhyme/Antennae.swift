//
//  Antennae.swift
//  rhyme
//
//  Created by Arjun Iyer on 11/15/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation



extension Dot {
    
    func fetchExactRhymes(_ string:String, completion: @escaping ([String])->()){
        
        let urlRequest = DataMuseRequestFactory.createExactRhymesRequest(string)
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion([])
                return
            }
            guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                completion([])
                return
            }
            
            
        }
        
        dataTask.resume()
        
    }
    
    
}
