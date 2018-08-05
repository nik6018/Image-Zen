//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Nikhil Muskur on 24/06/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import Foundation
import CoreData

enum FlickrError: String {
    case inValidJSONData
}

typealias ExtraParams = [String: String]

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
    case recent = "flickr.photos.getRecent"
    case search = "flickr.photos.search"
    case getUserInfo = "flickr.people.getInfo"
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "YOUR_API_KEY"
    
    private static var interestingPhotosURL: URL {
        return flickrURL(method: .recent, parameters: ["extras": "url_t,date_taken"])
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static func endPointURL(
        _ endPoint: Method,
        withParams params: ExtraParams = ["extras": "url_h,date_taken"]) -> URL {
        return FlickrAPI.flickrURL(method: endPoint, parameters: params)
    }
    
    private static func flickrURL(method: Method, parameters: [String: String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method" : method.rawValue,
            "format" : "json",
            "nojsoncallback" : "1",
            "api_key" : apiKey
        ]
        
        for (key, value) in baseParams {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        
        if let params = parameters {
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
}










