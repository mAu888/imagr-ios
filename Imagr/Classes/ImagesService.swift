//
//  ImagesService.swift
//  Imagr
//
//  Created by Mauricio Hanika on 02/08/15.
//  Copyright © 2015 Mauricio Hanika. All rights reserved.
//

import Foundation
import ReactiveCocoa

class ImagesService {
    private let dataProviders: [ImagesDataProvider]
    
    init?(dataProviders: [ImagesDataProvider]) {
        if 0 == dataProviders.count {
            self.dataProviders = []
            return nil
        }
        
        self.dataProviders = dataProviders
    }
    
    func rac_imagesForQueryString(queryString: String) -> RACSignal {
        var signals: [RACSignal] = []
        for provider in dataProviders {
            let signal = provider.rac_imagesForQueryString(queryString).`catch` { error in
                return RACSignal.`return`(nil)
            }
            signals.append(signal)
        }
        
        return RACSignal.combineLatest(signals)
            .map {
                let tuple = $0 as! RACTuple
                return tuple.rac_sequence
                    .filter { images -> Bool in
                        return !images.isKindOfClass(NSNull)
                    }
                    .foldLeftWithStart([], reduce: {
                        let first = $0 as! [Image]
                        let second = $1 as! [Image]
                        return first + second
                    })
        }
    }
}