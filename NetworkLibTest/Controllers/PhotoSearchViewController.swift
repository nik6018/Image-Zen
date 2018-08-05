//
//  ViewController.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 29/06/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PhotoSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchBarTopConstraint: NSLayoutConstraint!
    
    private let photoDataSource = PhotoDataSource()
    private var parser = Parser()
    private let imageCache = AutoPurgingImageCache()
    
    //MARK:- Controller Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        searchBar.delegate = self
        updateDataSource()
        updateNavBar()
        searchBarTopConstraint.constant = 0.0
        addCollectionViewObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //custom behavior
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- Searchbar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //clear the Existing DataSource
        photoDataSource.photos.removeAll()
        collectionView.reloadData()
        
        //now search
        if let text = searchBar.text {
            searchBar.resignFirstResponder()
            updateDataSource(withSearchTerm: text)
        }
    }
    
    
    
    //MARK:- CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
        let photo = photoDataSource.photos[indexPath.row]
        
        if let image = imageCache.image(withIdentifier: photo.photo_url) {
            let photoCell = cell as? PhotoCollectionViewCell
            photoCell?.updateCell(with: image, imageInfo: (photo.title, photo.photo_id))
        } else {
            //TODO : Implement most of this method in the Data Source or the Delegate ?? Think
            Alamofire.request(URL(string: photo.photo_url)!).responseData { (responseData) in
                
                guard let photoIndex = self.photoDataSource.photos.index(of: photo) else {
                    return
                }
                
                print("The Photo Index is: \(photoIndex)")
                
                let photoIndexPath = IndexPath(row: photoIndex, section: 0)
                
                if
                    let imageData = responseData.data,
                    let image = UIImage(data: imageData),
                    let photoCell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                    print("Got The Cell with image with title: \(photo.title) and Id : \(photo.photo_id)")
                    self.imageCache.add(image, withIdentifier: photo.photo_url)
                    photoCell.updateCell(with: image, imageInfo: (photo.title, photo.photo_id))
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: (self.searchBar.frame.height) + 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let edgeInsets = self.collectionView(
                                collectionView,
                                layout: collectionViewLayout,
                                insetForSectionAt: indexPath.section)
        
        let width = (collectionView.frame.width - edgeInsets.left - edgeInsets.right )
        return CGSize(width: width, height: 139)
    }
    
    //MARK:- Generate Data Source
    
    func updateDataSource(withSearchTerm term: String = "Elon Musk") {
        photoDataSource.fillDataSource(withSearchTerm: term) { (json) in
            let result = self.parser.getPhotos(from: json)
            switch result {
            case .success(let photos):
                print("The Count of Photos is : \(photos.count)")
                self.photoDataSource.photos = photos
                self.collectionView.reloadData()
            case .failure(let error):
                print("Cannot parse Photos due to error: \(error)")
                self.photoDataSource.photos.removeAll()
                self.collectionView.reloadData()
            }
        }   
    }
    
    //MARK:- Custom Search Bar Behaviour
    
    func addCollectionViewObserver() {
        collectionView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keypath = keyPath, keypath == "contentOffset", let collectionView = object as? UICollectionView {
            searchBarTopConstraint.constant = -1 * collectionView.contentOffset.y
        }
    }
    
    //MARK:- Setup Custom Nav bar
    
    func updateNavBar() {
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail View Search" {
            if let selectedIndex = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndex.row]
                let destinationVC = segue.destination as! PhotoDetailViewController
                destinationVC.imageCache = imageCache
                destinationVC.photo = photo
            }
            
        }
    }
}














