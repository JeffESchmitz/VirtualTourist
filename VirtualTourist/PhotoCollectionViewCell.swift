//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/10/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    static let identifier = String(PhotoCollectionViewCell)

    override func prepareForReuse() {
        super.prepareForReuse()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func updateCell(photo: Photo?) {
        
        if let photoImage = photo?.image {
            cellImageView.image = photoImage
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicatorView.stopAnimating()
            })
        }
        else {
            cellImageView.image = UIImage(named: "placeHolder")
        }
    }
    
}
