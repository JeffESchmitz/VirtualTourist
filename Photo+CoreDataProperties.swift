//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/13/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var title: String?
    @NSManaged var imageUrl: String?
    @NSManaged var imageData: NSData?
    @NSManaged var pin: Pin?

}
