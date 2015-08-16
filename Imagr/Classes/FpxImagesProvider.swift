//
//  FpxImagesProvider.swift
//  Imagr
//
//  Created by Mauricio Hanika on 02/08/15.
//  Copyright © 2015 Mauricio Hanika. All rights reserved.
//

import Foundation
import ReactiveCocoa

class FpxImagesProvider : ImagesDataProvider {
    let session: NSURLSession
    
    init(session: NSURLSession) {
        self.session = session
    }
    
    func requestURL(queryString: String) -> NSURL {
        let urlString = "https://api.500px.com/v1/photos/search?term=\(queryString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)&consumer_key=\(FpxAPIKey)"
        return NSURL(string:urlString)!
    }
    
    func images(fromData data: NSData?) -> [Image] {
        var images:[Image] = []
        if let d = data {
            
            do {
                let obj = try NSJSONSerialization.JSONObjectWithData(d, options: []) as! NSDictionary
                let photos:[NSDictionary] = obj.valueForKeyPath("photos") as! [NSDictionary]
                for p in photos {
                    images.append(Image(title: p["name"] as! String, thumbnailURL: NSURL(string:p["image_url"] as! String)!))
                }
                
            } catch {
                // #yolo
            }
            
        }
        
        return images
    }
    
}