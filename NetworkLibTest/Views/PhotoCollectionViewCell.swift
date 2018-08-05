//
//  PhotoCollectionViewCell.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 10/07/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageTitle: UILabel!
    @IBOutlet private weak var imageId: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    func updateCell(with image: UIImage?, imageInfo: (title: String, id: String)?) {
        if let imageToDisplay = image, let displayInfo = imageInfo {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
            imageTitle.text = displayInfo.title
            imageId.text = displayInfo.id
        } else {
            spinner.startAnimating()
            imageView.image = nil
            imageTitle.text = ""
            imageId.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateCell(with: nil, imageInfo: nil)
        imageView.layer.cornerRadius = 8.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateCell(with: nil, imageInfo: nil)
    }
    
}
