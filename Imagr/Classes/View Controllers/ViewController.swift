//
//  ViewController.swift
//  Imagr
//
//  Created by Mauricio Hanika on 16/08/15.
//  Copyright © 2015 Mauricio Hanika. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var searchQueryTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images : [Image]?
    lazy var imagesService = ImagesService(dataProviders: [FlickrImagesProvider(session: NSURLSession.sharedSession()), FpxImagesProvider(session: NSURLSession.sharedSession())])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagesSignal = searchQueryTextField
            .rac_signalForControlEvents(.EditingChanged)
            .map { textField -> AnyObject! in
                return (textField as! UITextField).text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) ?? ""
            }
            .distinctUntilChanged()
            .throttle(0.75) { queryString -> Bool in
                return 0 < ((queryString as? String)?.utf8.count ?? 0)
            }
            .map { queryString -> AnyObject! in
                if 0 == (queryString as! String).utf8.count {
                    return RACSignal.`return`(nil)
                } else {
                    return self.imagesService.rac_imagesForQueryString(queryString as! String)
                }
            }
            .switchToLatest()
            .deliverOnMainThread()
        
        // Bind
        imagesSignal ~> RAC(self, "images")
        
        RACObserve(self, keyPath: "images")
            .deliverOnMainThread()
            .subscribeNext { obj -> Void in
                self.collectionView.reloadData()
        }
        
        // Dismiss the keyboard once the return key has been pressed, no need to trigger the search again, as it will perform anyway
        searchQueryTextField.rac_signalForControlEvents(.EditingDidEndOnExit).subscribeNext { textField -> Void in
            (textField as! UITextField).resignFirstResponder()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchQueryTextField.becomeFirstResponder()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let image = self.images![indexPath.row]
        let cell: ImageCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCollectionCell.reuseIdentifier, forIndexPath: indexPath) as! ImageCollectionCell
        
        if nil == image.thumbnailImage {
            let imageSignal = NSData.rac_dataWithContentsOfURL(image.thumbnailURL)
                .map { data -> AnyObject! in
                    if let d = data as? NSData {
                        return UIImage(data:d)
                    } else {
                        return nil
                    }
            }
            imageSignal ~> RAC(image, "thumbnailImage")
        }
        
        cell.setImage(image)
        
        return cell
    }
}
