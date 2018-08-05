//
//  Photo.swift
//  
//
//  Created by Nikhil Muskur on 10/07/18.
//

import Foundation


struct Photo: Hashable {
    
    var hashValue: Int {
        return Int(photo_id)!
    }
    
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photo_id == rhs.photo_id
    }
    
    let title: String
    let photo_url: String
    let photo_id: String
    
    init(title: String, url: String, id: String) {
        self.title = title
        self.photo_url = url
        self.photo_id = id
    }
}
