//
//  Pin.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/8/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation
import CoreData


class Pin: NSManagedObject {

    convenience init(latitude: Double, longitude: Double, title: String, pageNumber: Int = 1, insertIntoManagedObjectContext context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            
            self.latitude = latitude
            self.longitude = longitude
            self.pinTitle = title
            self.pageNumber = pageNumber
        } else {
            fatalError("Unable to find entity 'Pin'")
        }
    }

}
