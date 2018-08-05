//
//  PhotoDataSource.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 10/07/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit
import Alamofire

enum PhotoReuseIdentifier:String {
    case reuseIdentifier = "PhotoCollectionViewCell"
}

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReuseIdentifier.reuseIdentifier.rawValue, for: indexPath) as! PhotoCollectionViewCell
        
        return cell
    }
    
    func fillDataSource(withSearchTerm term: String = "SR-71", completion: @escaping ([AnyHashable: Any]) -> Void) {
        let searchURL = FlickrAPI.endPointURL(.search, withParams: ["text": term,"extras":"url_s", "per_page": "10"])
        
        Alamofire.request(searchURL)
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
