//
//  RequestHandler.swift
//  Assignment5
//
//  Created by Boris Angelov on 31.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import Foundation

class ImageHandler {
    
    /// The session used to make each data task.
    lazy var session: URLSession = {
        let cache = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 80 * 1024 * 1024, diskPath: nil)
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }()
    
    /// Requests an image at the provided URL.
    func request(
        at url: URL,
        withCompletionHandler completion: @escaping (Data) -> (),
        andErrorHandler onError: @escaping (Error?, URLResponse?) -> ()
        ) {
        let task = session.dataTask(with: url) { (data, response, transportError) in
            
            guard transportError == nil, let data = data else {
                onError(transportError, nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                ["image/jpeg", "image/png"].contains(httpResponse.mimeType) else {
                    onError(nil, response)
                    return
            }
            
            completion(data)
        }
        
        task.resume()
    }
    
}
