//
//  Photo.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/8/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Photo: NSManagedObject {

    convenience init(title: String = "", imageUrl: String, image: UIImage? = nil, pin: Pin, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(Constants.Entity.Photo, inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            
            self.title = title
            self.imageUrl = imageUrl
            if let image = image {
                self.imageData = UIImagePNGRepresentation(image)
            }
            self.pin = pin
        }
        else {
            fatalError("Unable to find entity: Photo")
        }
    }

    
    var image: UIImage? {
        get {
            if let imageData = imageData {
                return UIImage(data: imageData)
            }
            else {
                return nil
            }
        }
    }
}
