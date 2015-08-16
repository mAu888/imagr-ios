//
//  NSData-RAC.swift
//  Imagr
//
//  Created by Mauricio Hanika on 16/08/15.
//  Copyright © 2015 Mauricio Hanika. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension NSData {
    class func rac_dataWithContentsOfURL(url: NSURL) -> RACSignal {
        return RACSignal.createSignal { subscriber -> RACDisposable! in
            if let data = NSData(contentsOfURL: url) {
                subscriber.sendNext(data)
            }
            
            // Don't care about errors, this is a demo #yolo
            subscriber.sendCompleted()
            
            return nil
            }.subscribeOn(RACScheduler(priority:RACSchedulerPriorityDefault))
    }
}
