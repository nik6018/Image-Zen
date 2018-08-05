//
//  PhotoFavouriteDataSource.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 30/07/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit

enum PhotoFavourite:String {
    case reuseIdentifier = "PhotoFavouriteCollectionViewCell"
    var name: String {
        return self.rawValue
    }
}

enum FetchResult {
    case success([FavouritePhoto])
    case failure(Error)
}

enum ToggleFavouriteResult {
    case success
    case failure(Error)
}

typealias FavouritePhoto = (image: UIImage, name: String)


class PhotoFavouriteDataSource: NSObject, UICollectionViewDataSource {
    
    var reuseIdentifier = PhotoFavourite.reuseIdentifier
    var photos = [FavouritePhoto]()
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
                                    withReuseIdentifier: reuseIdentifier.name,
                                    for: indexPath) as! PhotoFavouriteCollectionViewCell
        return cell
    }
    
    func getPhotosFromDisk(completion: @escaping (FetchResult) -> Void) {
        // get photos from the folder
        let path = getDocumentsDirectory()
        let fileManager = FileManager.default
        var fetchedPhotos = [FavouritePhoto]()
        
        do {
            let items = try fileManager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            
            for item in items {
                if let image = UIImage(contentsOfFile: item.path) {
                    fetchedPhotos.append((image, item.lastPathComponent))
                }
            }
            
            completion(.success(fetchedPhotos))
            
        } catch let error {
            // failed to read directory – bad permissions, perhaps?
            print(error)
            completion(.failure(error))
        }
        
        //then add to the Photos array
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
    
    func addAsFavourite(withImage image: UIImage,
                        named name: String,
                        completion: @escaping (ToggleFavouriteResult) -> Void) {
        let path = getDocumentsDirectory()
        
        do {
            if let data = UIImagePNGRepresentation(image) {
                let filename = path.appendingPathComponent(name)
                try data.write(to: filename)
            }
            
            completion(.success)
        } catch let error {
            //Cannot save the image
            completion(.failure(error))
            print("Unable to save to disk due to error: \(error)")
        }
    }
    
    func removeAsFavourite(withImage image: UIImage,
                           named name: String,
                           completion: @escaping (ToggleFavouriteResult) -> Void) {
        let path = getDocumentsDirectory()
        let fileManager = FileManager.default
        
        do {
            
            let filename = path.appendingPathComponent(name)
            try fileManager.removeItem(at: filename)
            completion(.success)
        } catch let error {
            //Cannot save the image
            completion(.failure(error))
            print("Unable to delete from disk due to error: \(error)")
        }
    }
}






