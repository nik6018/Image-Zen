//
//  PhotoHomeViewController.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 27/07/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PhotoHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let dataSource = PhotoHomeDataSource()
    private let parser = Parser()
    private let imageCache = AutoPurgingImageCache()

    //MARK:- Controller Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        updateDataSource()
        
        //Setup Nav Bar
        setUpNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Custom Behaviour
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0.5, left: 0, bottom: 0.5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        if indexPath.row == 0 {
            let width = collectionView.frame.width
            print("The Wdith is : \(width)  \(#function)")
            let height = width * 0.70
            return CGSize(width: width, height: height)
        } else {
            let width = ((collectionView.frame.width / 4) - 1)
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = dataSource.photos[indexPath.row]
        
        Alamofire.request(URL(string: photo.photo_url)!).responseData { (responseData) in
            
            guard let photoIndex = self.dataSource.photos.index(of: photo) else {
                return
            }
            
            let photoIndexPath = IndexPath(row: photoIndex, section: 0)
            
            if
                let imageData = responseData.data,
                let image = UIImage(data: imageData) {
                
                if photoIndex == 0 {
                    if let swipeCell = self.collectionView.cellForItem(at: photoIndexPath) as? SwipeCollectionViewCell {
                        self.imageCache.add(image, withIdentifier: photo.photo_url)
                        swipeCell.fillCell(withImages: [image, image, image])
                    }
                } else {
                    if let photoCell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoHomeCollectionViewCell {
                        self.imageCache.add(image, withIdentifier: photo.photo_url)
                        photoCell.updateCell(withImage: image)
                    }
                }
            }
        }
        
        if let photoCell = collectionView.cellForItem(at: indexPath) as? PhotoHomeCollectionViewCell {
            photoCell.updateCell(withImage: nil)
        }
    }
    
    //MARK: - Data Source
    
    private func updateDataSource() {
        dataSource.fillTheDataSource { (json) in
            let result = self.parser.getPhotos(from: json, fromHomeVC: true)
            switch result {
            case .success(let photos):
                print("The Count of Photos is : \(photos.count)")
                self.dataSource.photos = photos
                self.collectionView.reloadData()
            case .failure(let error):
                print("Cannot parse Photos due to error: \(error)")
                self.dataSource.photos.removeAll()
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Setup Nav Bar
    
    private func setUpNavBar() {
        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail View Home" {
            if let selectedIndex = collectionView.indexPathsForSelectedItems?.first {
                let photo = dataSource.photos[selectedIndex.row]
                let destinationVC = segue.destination as! PhotoDetailViewController
                destinationVC.imageCache = imageCache
                destinationVC.photo = photo
            }
        }
    }
}





