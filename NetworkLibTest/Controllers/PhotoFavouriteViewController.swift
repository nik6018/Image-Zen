//
//  PhotoFavouriteViewController.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 30/07/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit

class PhotoFavouriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var dataSource = PhotoFavouriteDataSource()
    private var selectedImageIndexPath: IndexPath!
    
    //MARK:- Controller Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        setUpNavBar()
        updateDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //custom behaviour
        self.tabBarController?.tabBar.isHidden = false
        updateDataSource()
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ((collectionView.frame.width / 3) - 1)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.5, left: 0, bottom: 0.5, right: 0)
    }
    
    //MARK: -  UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = dataSource.photos[indexPath.row]
        
        //IMPROVEMENT: -  Once images are loaded from disk keep them image cache
        if let pCell = cell as? PhotoFavouriteCollectionViewCell {
            pCell.updateCell(withImage: photo.image)
        }
    }
    
    //MARK:- Setup DataSource
    
    private func updateDataSource() {
        // call the fill method in the datasource
        dataSource.getPhotosFromDisk { (result) in
            switch result {
            case .success(let photos):
                self.dataSource.photos = photos
                self.collectionView.reloadData()
            case .failure(let error):
                let alertController = UIAlertController(title: "Failed Action", message: "Unable to Fetch Favourite Photo due to error: \(error)", preferredStyle: .alert)
                let okAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAlertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Setup Nav Bar
    
    private func setUpNavBar() {
        self.navigationItem.title = "Favourites"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail View Favourite" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                selectedImageIndexPath = indexPath
                let photo = dataSource.photos[indexPath.row]
                let destVC = segue.destination as! PhotoDetailViewController
                destVC.fromFavouriteVC = true
                destVC.favImage = photo
            }
        }
    }

}
