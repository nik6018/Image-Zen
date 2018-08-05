//
//  SwipeCollectionViewCell.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 02/08/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit

class SwipeCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet private weak var collectionView: UICollectionView!
    var dataSource: PhotoSwipeDataSource?
    @IBOutlet private weak var pageControl: UIPageControl!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dataSource = nil
        collectionView.dataSource = nil
    }
    
    func fillCell(withImages images: [UIImage]) {
        dataSource = PhotoSwipeDataSource(withImages: images)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.reloadData()
        
        pageControl.numberOfPages = (dataSource?.swipePhotos.count)!
    }
    
    //MARK:- UICollectionView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = width * 0.70
        return CGSize(width: width, height: height)
    }
    
    // helper method for page control
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPage = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(indexPage)
    }
}




