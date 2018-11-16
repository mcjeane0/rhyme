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
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, responseError) in
            guard responseError == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion([])
                return
            }
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]] {
                    let wordArray = jsonArray.map({ (datamuseRhymeEntry) -> String in
                        return datamuseRhymeEntry["word"] as! String
                    })
                    completion(wordArray)
                }
            }
            catch{
                NSLog("catch:error:\(error)")
            }
            
        }
        
        dataTask.resume()
        
    }
    
    func fetchApproximateRhymes(_ string:String, completion: @escaping ([String])->()){
        
        let urlRequest = DataMuseRequestFactory.createApproximateRhymesRequest(string)
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, responseError) in
            guard responseError == nil, let urlResponse = response as? HTTPURLResponse else {
                completion([])
                return
            }
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]] {
                    let wordArray = jsonArray.map({ (datamuseRhymeEntry) -> String in
                        return datamuseRhymeEntry["word"] as! String
                    })
                    completion(wordArray)
                }
            }
            catch{
                NSLog("catch:error:\(error)")
            }
            
        }
        
        dataTask.resume()
        
    }
    
    
}
