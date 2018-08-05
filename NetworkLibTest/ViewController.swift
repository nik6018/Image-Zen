//
//  ViewController.swift
//  NetworkLibTest
//
//  Created by Nikhil Muskur on 29/06/18.
//  Copyright © 2018 Nikhil Muskur. All rights reserved.
//

import UIKit
import Alamofire

class PhotoSearchViewController: UIViewController {

   @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("The Document URL is \(documentURL.absoluteString)")
        
        simpleTest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadTest() {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            print("The Document URL is \(documentURL.absoluteString)")
            let fileURL = documentURL.appendingPathComponent("mysql.tar.gz")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let urlString = "https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.11.tar.gz"
        
        Alamofire.download(urlString, to: destination)
            .downloadProgress(closure: { (progress) in
                print("Download Progress : \(progress.fractionCompleted)")
            })
            .response { (response) in
            print(response)
            
            if response.error == nil, let _ = response.destinationURL?.path {
                print("YAY MySQL downloaded....")
            }
        }
        
    }
    
    func postTest() {
        
        let param: Parameters = ["name": "nikhil"]
        
        Alamofire.request("https://134.compilor.com/post.php", method: .post, parameters: param)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                print("Request: \(String(describing: response.request))")
                print("Response TimeLIne: \(String(describing: response.timeline))")
                print("Result: \(response.result)")
                
                switch response.result {
                case .success:
                    if let json = response.result.value {
                        print("JSON: \(json)")
                    }
                case .failure(let err):
                    print("The Request failed Due to: \(err)")
                    
                }
                
            }
    }
    
    func simpleTest() {
        
//        let url = "https://api.flickr.com/services/rest?api_key=a6d819499131071f158fd740860a5a88&method=flickr.photos.search&format=json&nojsoncallback=1&text=cow&extras=url_h&per_page=50"
        
        let searchURL = FlickrAPI.endPointURL(.search, withParams: ["text": "train","extras":"url_h", "per_page": "50"])
        let infoURL = FlickrAPI.endPointURL(.getUserInfo, withParams: ["user_id": "42603972274"])
        
        Alamofire.request(searchURL)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
            
            //print("Request: \(String(describing: response.request))")
            //print("Response: \(String(describing: response.response))")
            //print("Result: \(response.result)")
            
            
            
                
            switch response.result {
            case .success:
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
            case .failure(let err):
                print("The Request failed Due to: \(err)")
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
        
    }
}













