//
//  ViewController.swift
//  InstaTimeMachine
//
//  Created by Tom Lee on 5/16/16.
//  Copyright (c) 2016 Tom Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = NSMutableArray()
    
    override func viewDidLoad() {
        self.collectionView.allowsSelection = true
        super.viewDidLoad()
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let request = NSURLRequest(URL: NSURL(string: "https://api.instagram.com/v1/users/self/media/recent/?access_token=245515478.1677ed0.989ac365b653414a96c00524134d6788&count=20")!)
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let data = data {
                if let parsedJSON = NSJSONSerialization.JSONObjectWithData(data, options: nil, error:nil) as? NSDictionary {

                    let photoObjects = parsedJSON["data"] as! NSArray
                    for photoObject in photoObjects {
                        let photoURLString: String = photoObject["images"]!!.valueForKeyPath("standard_resolution.url")! as! String
                        let photoURL = NSURL(string: photoURLString)
                        let photoData = NSData(contentsOfURL: photoURL!)
                        self.photos.addObject(photoData!)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView.reloadData()
                    });
                } else {
                    println("Could not parse the JSON correctly")
                }
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(self.photos.count)
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.imageView?.image = (UIImage(data: self.photos[indexPath.row] as! NSData))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("Pressed Cell")
        
        if(indexPath.item == 0)
        {
            //self.navigationController?.popToViewController(profileViewController, animated: true)
        }
        
    }
    /*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("here")
        
        
        self.performSegueWithIdentifier("showImage", sender: self)
    }
    */
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()
            let indexPath = indexPaths[0] as! NSIndexPath
            
            let vc = segue.destinationViewController as! PhotoDetailViewController
            
            vc.image = self.imageArray[indexPath.row]!
            vc.title = self.appleProducts[indexPath.row]
            
        }
    }
    */
}

