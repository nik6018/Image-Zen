//
//  PhotoDetailViewController.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 27/07/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoDetailViewController: UIViewController {

    @IBOutlet private weak var detailImageView: UIImageView!
    var imageCache: AutoPurgingImageCache!
    var photo: Photo! {
        didSet {
            self.navigationItem.title = photo.title
        }
    }
    var dataSource = PhotoFavouriteDataSource()
    var fromFavouriteVC = false
    var favImage: FavouritePhoto!
    
    //MARK:- Controller Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Custom Behaviour
        setUpNavBar()
        imageSetUp()
    }
    
    //MARK:- Setup Nav Bar
    
    private func setUpNavBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = UIColor.black
        self.tabBarController?.tabBar.isHidden = true
        
        var heartImage = #imageLiteral(resourceName: "heart-empty")
        var selector = #selector(markPhotoAsFavourite(_:))
        
        if fromFavouriteVC {
            //Create the Favourite Button
            heartImage = #imageLiteral(resourceName: "heart-filled")
            selector = #selector(unMarkPhotoAsFavourite(_:))
        }
        
        let favButton = UIBarButtonItem(
            image: heartImage,
            style: .plain,
            target: self,
            action: selector)
        
        self.navigationItem.rightBarButtonItem = favButton
        
    }
    
    //MARK:- Custom Image View Setup
    
    private func imageSetUp() {
        if fromFavouriteVC && favImage != nil {
            // if segueing from FavouritesVC
            detailImageView.image = favImage.image
        } else if let image = imageCache.image(withIdentifier: photo.photo_url) {
            // if segueing from SearchVC or HomeVC
            let imageFilter = RoundedCornersFilter(radius: 15.0)
            let fileteredImage = imageFilter.filter(image)
            detailImageView.image = fileteredImage
        } else {
            // if tried to access directly
            detailImageView.backgroundColor = UIColor.darkGray
        }
    }
    
    //MARK:- Action Methods
    
    @objc private func markPhotoAsFavourite(_ sender: Any?) {
        if let favImage = detailImageView.image {
            //TODO: Add error handling (pass closure to handle the result of write operation)
            dataSource.addAsFavourite(withImage: favImage, named: photo.photo_id) { result in
                switch result {
                case .success:
                    self.displayAlert(withTitle: "Sucessfull", andMessage: "Image saved as Favourite")
                case .failure(let err):
                    self.displayAlert(
                            withTitle: "Failed",
                            andMessage: "Unable to save image as Favourite due to Error: \(err)")
                }
            }
        }
    }
    
    @objc private func unMarkPhotoAsFavourite(_ sender: Any?) {
        if let image = detailImageView.image {
            //TODO: Add error handling (pass closure to handle the result of write operation)
            dataSource.removeAsFavourite(withImage: image, named: favImage.name) { result in
                let barButton = sender as! UIBarButtonItem
                barButton.image = #imageLiteral(resourceName: "heart-empty")
                
                switch result {
                case .success:
                    self.displayAlert(withTitle: "Sucessfull", andMessage: "Image removed as Favourite")
                case .failure(let err):
                    self.displayAlert(
                            withTitle: "Failed",
                            
                            andMessage: "Unable to remove image as Favourite due to Error: \(err)")
                }
            }
        }
    }
    
    // helper method
    
    private func displayAlert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
