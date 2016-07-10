//
//  Pin.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/8/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Pin: NSManagedObject {

    convenience init(latitude: Double, longitude: Double, title: String, subtitle: String = "", pageNumber: Int = 1, context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            
            self.latitude   = latitude
            self.longitude  = longitude
            self.title      = title
            self.subtitle   = subtitle
            self.pageNumber = pageNumber
            
        } else {
            fatalError("Unable to find entity 'Pin'")
        }
    }

}

// MARK: - MKAnnotaion protocol
extension Pin: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        
        get {
          return CLLocationCoordinate2DMake(latitude as! CLLocationDegrees, longitude as! CLLocationDegrees)
        }
        
        set {
            willChangeValueForKey("coordinate")

            self.latitude = newValue.latitude
            self.longitude = newValue.longitude
            
            didChangeValueForKey("coordinate")
        }
    }

}
