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

    convenience init(imageUrl: String, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(Constants.Entity.Photo, inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            
            self.url = imageUrl
            self.image = nil
        }
        else {
            fatalError("Unable to find entity: Photo")
        }
    }

//    convenience init(imageUrl: String, context: NSManagedObjectContext) {
//        if let entity = NSEntityDescription.entityForName(Constants.Entity.Photo, inManagedObjectContext: context) {
//            self.init(entity: entity, insertIntoManagedObjectContext: context)
//            
//            self.url = imageUrl
//            self.image = nil
//        }
//        else {
//            fatalError("Unable to find entity: Photo")
//        }
//    }

//    var image: UIImage? {
//        get {
//            if let imageData = imageData {
//                return UIImage(data: self.imageData)
//            }
//        }
//    }
    
}
