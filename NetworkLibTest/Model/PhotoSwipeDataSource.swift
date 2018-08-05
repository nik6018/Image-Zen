//
//  PhotoSwipeDataSource.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 02/08/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit

enum PhotoFullWidth:String {
    case reuseIdentifier = "PhotoFullWidthCollectionViewCell"
    var name: String {
        return self.rawValue
    }
}

class PhotoSwipeDataSource: NSObject, UICollectionViewDataSource {
    
    var swipePhotos = [UIImage]()
    var identifier = PhotoFullWidth.reuseIdentifier
    
    init(withImages images: [UIImage]) {
        super.init()
        
        self.swipePhotos = images
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return swipePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let image = swipePhotos[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier.name, for: indexPath) as! PhotoHomeCollectionViewCell
        
        cell.updateCell(withImage: image, contentMode: .scaleAspectFit)
        
        return cell
    }
}
