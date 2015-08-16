//
//  ImageCollectionCell.swift
//  Imagr
//
//  Created by Mauricio Hanika on 16.08.15.
//  Copyright © 2015 Mauricio Hanika. All rights reserved.
//

import UIKit
import ReactiveCocoa

@objc
class ImageCollectionCell : UICollectionViewCell {
    static let reuseIdentifier = "ImageCollectionCellIdentifier"
    @IBOutlet private(set) internal weak var imageView: UIImageView!
    
    func setImage(image: Image) -> Void {
        let dataSignal = RACObserve(image, keyPath: "thumbnailImage")
            .takeUntil(self.rac_prepareForReuseSignal)
            .deliverOnMainThread()
        dataSignal ~> RAC(self.imageView, "image")
    }
}
