//
//  PhotoFavouriteCollectionViewCell.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 30/07/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit

class PhotoFavouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func updateCell(withImage image: UIImage?) {
        
        if let favImage = image {
            imageView.image = favImage
            backgroundColor = UIColor.clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //custom behaviour
        updateCell(withImage: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //custom behaviour
        updateCell(withImage: nil)
    }
    
}
