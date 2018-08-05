//
//  Parser.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 11/07/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import Foundation

enum ParseResult {
    case success([Photo])
    case failure(Error)
}


class Parser: NSObject {
    
    func getPhotos(from jsonData: [AnyHashable: Any], fromHomeVC: Bool = false) -> ParseResult {

        guard
            let responseObj = jsonData["photos"] as? [String: Any],
            let photosObj = responseObj["photo"] as? [[String: Any]] else{
                return .failure("Cannot Parse the JSON" as! Error)
            }
        
        var extractedPhotos = [Photo]()
        print("The Actual Object: \(responseObj)")
        
        for rawPhotoObject in photosObj {
            if let photo = createPhotoObjects(fromJSON: rawPhotoObject) {
                extractedPhotos.append(photo)
            }
        }
        
        //NOTE:- Array manipulation for Full width photos
        if fromHomeVC {
            let subRange = extractedPhotos[0..<3]
            extractedPhotos.replaceSubrange(0..<3, with: subRange)
        }
        
        return .success(extractedPhotos)
    }
    
    func createPhotoObjects(fromJSON jsonData: [String: Any]) -> Photo? {
        
        guard
            let photoURL = jsonData["url_s"] as? String,
            let photoID = jsonData["id"] as? String,
            let photoTitle = jsonData["title"] as? String else {
            return nil
        }
        
        return Photo(title: photoTitle, url: photoURL, id: photoID)
    }
    
}
