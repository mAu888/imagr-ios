//
//  Image.swift
//  Imagr
//
//  Created by Mauricio Hanika on 02/08/15.
//  Copyright © 2015 Mauricio Hanika. All rights reserved.
//

import UIKit

class Image : NSObject {
    let title: String
    let thumbnailURL: NSURL
    var thumbnailImage: UIImage?
    
    init(title: String, thumbnailURL: NSURL) {
        self.title = title
        self.thumbnailURL = thumbnailURL
    }
}