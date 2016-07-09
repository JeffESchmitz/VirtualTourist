//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/6/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deletePinsLabel: UILabel!
    
    // MARK: Properties
    private var droppedPin: Pin!
//    private var coreDataStack: CoreDataStack!
    
    private lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create a fetch request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        // Sort the pins by latitude
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.Latitude, ascending: true)]
        
        // Make our FetchedResultsController
        let stack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: stack.context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
    }()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem()
        deletePinsLabel.hidden = true

        // Set a refence to the CoreDataStack
//        coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        
        centerMapOnLastLocation()

        fetchPins()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let pins = fetchedResultsController.fetchedObjects as? [Pin] else {
            print("fetchedObjects nil, returned no Pins - WTH?")
            return
        }
        addPinsToMap(pins)
    }
    
    @IBAction func handleAddPinToMap(sender: UILongPressGestureRecognizer) {
        guard editing == false else {
            return
        }
        
        let touchedPosition = sender.locationInView(mapView)
        let mapCoordinate = mapView.convertPoint(touchedPosition, toCoordinateSpace: mapView)
        
        switch sender.state {
        case .Began:
//            droppedPin =
            break
        
        case .Changed:
            
            break
        
        case .Ended, .Cancelled:
            
            break
            
        default:
            break
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing == true {
            deletePinsLabel.hidden = false
        } else {
            deletePinsLabel.hidden = true
        }
    }
    
    func centerMapOnLastLocation() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        guard (userDefaults.objectForKey(Constants.MapLatitude) != nil
            && userDefaults.objectForKey(Constants.MapLongitude) != nil) else {
            return
        }
        
        let latitude = userDefaults.doubleForKey(Constants.MapLatitude)
        let longitude = userDefaults.doubleForKey(Constants.MapLongitude)
        let latitudeDelta = userDefaults.doubleForKey(Constants.MapLatitudeDelta)
        let longitudeDelta = userDefaults.doubleForKey(Constants.MapLongitudeDelta)
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let coordinateRegion = MKCoordinateRegionMake(location, coordinateSpan)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func fetchPins() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            displayMessage("Unable to retrieve Pin's. Check the database for any Pin records.", title: "Fetch Failed")
        }
    }
    
    func addPinsToMap(pins: [Pin]) {
        for pin in pins {
//            mapView.addAnnotation(Pin)
        }
    }
    
}

// MARK: -   MKMapViewDelegate
extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()

        userDefaults.setDouble(mapView.region.center.latitude, forKey: Constants.MapLatitude)
        userDefaults.setDouble(mapView.region.center.longitude, forKey: Constants.MapLongitude)
        
        userDefaults.setDouble(mapView.region.span.latitudeDelta, forKey: Constants.MapLatitudeDelta)
        userDefaults.setDouble(mapView.region.span.longitudeDelta, forKey: Constants.MapLongitudeDelta)
        userDefaults.synchronize()
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        fatalError("Not Implemented")
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        fatalError("Not Implemented")
    }
}


