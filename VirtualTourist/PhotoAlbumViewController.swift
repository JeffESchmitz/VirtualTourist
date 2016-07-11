//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/10/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var refreshRemoveButton: UIBarButtonItem!
    
    // MARK: - Properties
    var pin: Pin!
//    lazy var pin: Pin = Pin()
    private var coreDataStack: CoreDataStack!
    private lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create a fetch request
        let fetchRequest = NSFetchRequest(entityName: Constants.Entity.Photo)
        
        // Sort the pins by latitude
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.Entity.Title, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin)
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.coreDataStack.context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    // For CoreData to keep track of insertions and deletions
    private var insertedIndexPaths: [NSIndexPath]!
    private var deletedIndexPaths: [NSIndexPath]!
    private var updatedIndexPaths: [NSIndexPath]!

    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
        
        // Set a refence to the CoreDataStack
        coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack

        fetchPhotos()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.layoutIfNeeded()
        refreshRemoveButton.enabled = true
    }
    // MARK: - Actions
    
    

    // MARK: - Class functions
    private func initializeView() {
        
        fetchedResultsController.delegate = self

        automaticallyAdjustsScrollViewInsets = false
        
        initializeMap()
        
        refreshRemoveButton.enabled = false
    }
    
    private func fetchPhotos() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            displayMessage("Unable to retrieve Photo's. Check the database for existing Photo records.", title: "Fetch Failed")
        }
    }
    
    private func initializeMap() {

        guard pin.latitude != nil && pin.longitude != nil else {
            displayMessage("latitude - longitude not set", title: "Pin Error")
            return
        }
        
        let region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpanMake(1.0, 1.0))
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(pin)
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            insertedIndexPaths.append(newIndexPath!)
            break
        
        case .Delete:
            deletedIndexPaths.append(indexPath!)
            break
            
        case .Update:
            updatedIndexPaths.append(indexPath!)
            break
            
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.performBatchUpdates({ 
            self.collectionView.deleteItemsAtIndexPaths(self.deletedIndexPaths)
            self.collectionView.insertItemsAtIndexPaths(self.insertedIndexPaths)
            self.collectionView.reloadItemsAtIndexPaths(self.updatedIndexPaths)
            }, completion: nil)
    }
}


// MARK: - UICollectionViewDataSource
extension PhotoAlbumViewController: UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return PhotoCollectionViewCell()
    }
}



// MARK: - UICollectionViewDelegate
extension PhotoAlbumViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        fatalError("Not Implemented Yet")
    }
    
    
}
