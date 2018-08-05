//
//  PhotoHomeDataSource.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 27/07/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit
import Alamofire

enum PhotoHomeReuse:String {
    case reuseIdentifier = "PhotoHomeCollectionViewCell"
    case reuseIdentifierSwipeCell = "PhotoSwipeCollectionViewCell"
    var name:String {
        return self.rawValue
    }
}

class PhotoHomeDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [Photo]()
    var identifier = PhotoHomeReuse.reuseIdentifier
    var identifierSwipeCell = PhotoHomeReuse.reuseIdentifierSwipeCell
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: identifierSwipeCell.name,
                for: indexPath) as! SwipeCollectionViewCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                                withReuseIdentifier: identifier.name,
                                for: indexPath) as! PhotoHomeCollectionViewCell
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func fillTheDataSource(completion: @escaping ([AnyHashable: Any]) -> Void) {
        let requestURL = FlickrAPI.endPointURL(.interestingPhotos, withParams: ["extras":"url_s", "per_page": "50"])
        
        Alamofire.request(requestURL)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let json = response.result.value as? [AnyHashable: Any] {
                        print("The JSON: \(json)")
                        completion(json)
                    }
                case .failure(let err):
                    print("The Request failed Due to: \(err)")
                    
                }
        }
    }
    
}
