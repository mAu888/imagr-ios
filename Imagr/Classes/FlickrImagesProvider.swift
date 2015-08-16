//
//  FlickrImagesProvider.swift
//  Imagr
//
//  Created by Mauricio Hanika on 02/08/15.
//  Copyright © 2015 Mauricio Hanika. All rights reserved.
//

import Foundation
import ReactiveCocoa

class FlickrImagesProvider : ImagesDataProvider {
    let session: NSURLSession
    
    init(session: NSURLSession) {
        self.session = session
    }
    
    func requestURL(queryString: String) -> NSURL {
        let sanitized = queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FlickrAPIKey)&text=\(sanitized!)&format=json&nojsoncallback=1"
        return NSURL(string:urlString)!
    }
    
    func images(fromData data:NSData?) -> [Image] {
        var images:[Image] = []
        if let d = data {
            
            do {
                let obj = try NSJSONSerialization.JSONObjectWithData(d, options: []) as! NSDictionary
                if let photos:[NSDictionary] = obj.valueForKeyPath("photos.photo") as? [NSDictionary] {
                    for p in photos {
                        images.append(Image(title: p["title"] as! String, thumbnailURL: self.photoThumbnailUrl(p)))
                    }
                }
                
            } catch {
                // #yolo
            }
            
        }
        
        return images
    }
    
    private func photoThumbnailUrl(photo: NSDictionary) -> NSURL {
        let farmId = photo["farm"] as! NSNumber
        let serverId = photo["server"] as! String
        let photoId = photo["id"] as! String
        let secret = photo["secret"] as! String
        
        let urlString = "https://farm\(farmId.integerValue).staticflickr.com/\(serverId)/\(photoId)_\(secret).jpg"
        return NSURL(string: urlString)!
    }
}