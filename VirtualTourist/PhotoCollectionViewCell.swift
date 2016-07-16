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
        
        activityIndicatorView.startAnimating()
    }
    
    func updateCell(photo: Photo?) {
        
        if let photoImage = photo?.image {
            cellImageView.image = photoImage
            activityIndicatorView.stopAnimating()
        }
        else {
            cellImageView.image = UIImage(named: "placeHolder")
        }
    }
    
    // From the old iOS Persistence (step 5.5) to cancel the previous task when a value is set
    var taskToCancelIfCellIsReused: NSURLSessionTask? {
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
    
}
