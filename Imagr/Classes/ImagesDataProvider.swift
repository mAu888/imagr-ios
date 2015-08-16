//
//  ImagesDataProvider.swift
//  Imagr
//
//  Created by Mauricio Hanika on 02/08/15.
//  Copyright © 2015 Mauricio Hanika. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol ImagesDataProvider {
    var session: NSURLSession { get }
    
    func requestURL(queryString: String) -> NSURL
    func images(fromData data: NSData?) -> [Image]
}

extension ImagesDataProvider {
    // Swift 2.0 protocol extensions <3
    func rac_imagesForQueryString(queryString: String) -> RACSignal {
        return RACSignal.createSignal { subscriber -> RACDisposable! in
            let task = self.session.dataTaskWithURL(self.requestURL(queryString)) { data, response, error in
                let httpResponse = response as! NSHTTPURLResponse
                if let e = error {
                    subscriber.sendError(e)
                } else if httpResponse.statusCode != 200 {
                    subscriber.sendError(NSError(domain: "ImagesDataProvider", code: 1, userInfo: nil))
                } else {
                    let images = self.images(fromData: data!)
                    subscriber.sendNext(images)
                    subscriber.sendCompleted()
                }
            }
            task.resume()
            
            return RACDisposable {
                if task.state == .Running || task.state == .Suspended {
                    task.cancel()
                }
            }
        }
    }
}