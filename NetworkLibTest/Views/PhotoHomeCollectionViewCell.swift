//
//  PhotoHomeCollectionViewCell.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 27/07/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit

typealias CM = UIViewContentMode

class PhotoHomeCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet private weak var imageView: UIImageView!
   
    func updateCell(withImage image: UIImage?, contentMode: CM = .scaleAspectFill) {
        if let displayImage = image {
            imageView.contentMode = contentMode
            imageView.image = displayImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //custom behavior
        updateCell(withImage: nil)
        imageView.backgroundColor = UIColor.black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //custom behavior
        updateCell(withImage: nil)
        imageView.backgroundColor = UIColor.black
    }
}
