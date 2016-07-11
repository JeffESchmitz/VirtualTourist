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
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deletePinsLabel: UILabel!
    
    // MARK: Properties
    private lazy var droppedPin: Pin = Pin()
    private var coreDataStack: CoreDataStack!
    private lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create a fetch request
        let fetchRequest = NSFetchRequest(entityName: Constants.Entity.Pin)
        
        // Sort the pins by latitude
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.Latitude, ascending: true)]
        

        let stackContext = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.context
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: stackContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem()
        deletePinsLabel.hidden = true

        // Set a refence to the CoreDataStack
        coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        
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

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing == true {
            deletePinsLabel.hidden = false
        } else {
            deletePinsLabel.hidden = true
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.OpenPhotoAlbum {
            let destinationViewController = segue.destinationViewController as! PhotoAlbumViewController
            destinationViewController.pin = sender as! Pin
        }
    }
    
    @IBAction func handleAddPinToMap(sender: UILongPressGestureRecognizer) {
        guard editing == false else {
            return
        }
        
        let touchedPosition = sender.locationInView(mapView)
        let mapCoordinate = mapView.convertPoint(touchedPosition, toCoordinateFromView: mapView)
        
        switch sender.state {
        case .Began:
            droppedPin = Pin(latitude: mapCoordinate.latitude, longitude: mapCoordinate.longitude, title: "", context: coreDataStack.context)
            mapView.addAnnotation(droppedPin)
            break
        
        case .Changed:
            droppedPin.coordinate = mapCoordinate
            break
        
        case .Ended, .Cancelled:
            coreDataStack.save()
            break
            
        default:
            break
        }
    }
    
    
    // MARK: - Class functions
    private func centerMapOnLastLocation() {
        
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

    private func fetchPins() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            displayMessage("Unable to retrieve Pin's. Check the database for any Pin records.", title: "Fetch Failed")
        }
    }
    
    private func addPinsToMap(pins: [Pin]) {
        for pin in pins {
            mapView.addAnnotation(pin)
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
    
//    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
//        fatalError("Not Implemented")
//    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.MapReuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.MapReuseId)
            pinView?.canShowCallout = false
            pinView?.pinTintColor = Constants.ColorPalette.UdacityBlue
        } else {
            pinView?.annotation = annotation
        }
        pinView?.draggable = true
        pinView?.animatesDrop = true
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        guard let pin = view.annotation as? Pin else {
            displayMessage("setting selected Pin: '\(view.annotation)'", title: "Error")
            return
        }
        
        if editing {
            mapView.removeAnnotation(pin)
            coreDataStack.context.deleteObject(pin)
            coreDataStack.save()
        } else {
            mapView.deselectAnnotation(pin, animated: true)
            performSegueWithIdentifier(Constants.OpenPhotoAlbum, sender: pin)
        }
    }
}


