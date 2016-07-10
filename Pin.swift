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

    convenience init(latitude: Double, longitude: Double, title: String, pageNumber: Int = 1, context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            
            self.latitude = latitude
            self.longitude = longitude
            self.pinTitle = title
            self.pageNumber = pageNumber
        } else {
            fatalError("Unable to find entity 'Pin'")
        }
    }

}

//// MARK: - MKAnnotaion protocol
//extension Pin: MKAnnotation {
//    
//    // Center latitude and longitude of the annotation view.
//    // The implementation of this property must be KVO compliant.
//    public var coordinate: CLLocationCoordinate2D {
//        
//    }
//}