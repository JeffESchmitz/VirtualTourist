//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/9/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var pageNumber: NSNumber?
    @NSManaged var title: String?
    @NSManaged var subtitle: String?
    @NSManaged var photos: NSSet?

}
