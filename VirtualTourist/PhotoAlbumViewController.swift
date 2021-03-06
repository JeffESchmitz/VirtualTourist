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
    lazy var pin: Pin = Pin()
    private var coreDataStack: CoreDataStack!
    private lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create a fetch request
        let fetchRequest = NSFetchRequest(entityName: Constants.Entity.Photo)
        
        // Sort the pins by latitude
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.Entity.Title, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin)
        
        let stackContext = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.context
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: stackContext,
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
        
        toggleNoImagesLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshRemoveButton.enabled = true
        // Subscribe to notification of when all images are completed downloading and saved.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoAlbumViewController.finishedDownloadingImages(_:)), name: Constants.AllFilesDownloaded, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.layoutIfNeeded()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Unsubscribe from notification
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.AllFilesDownloaded, object: nil)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing == true {
            refreshRemoveButton.title = "Tap photos to delete"
        } else {
            refreshRemoveButton.title = "New Collection"
            guard let selectedItems = collectionView.indexPathsForSelectedItems() else {
                return
            }
            for indexPath in selectedItems {
                collectionView.deselectItemAtIndexPath(indexPath, animated: true)
                collectionView.cellForItemAtIndexPath(indexPath)!.alpha = 1.0
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.OpenPhotoDetail {
            let viewController = segue.destinationViewController as! PhotoDetailViewController
            
            let selectedPhoto = sender as! Photo
            print("selectedPhoto: \(selectedPhoto)")
            
            viewController.photo = selectedPhoto
        }
    }
    
    
    // MARK: - Actions
    @IBAction func refreshRemoveButtonTouched(sender: AnyObject) {
        
        // For purposes of this app (and view), editing is equivilant to "mark for delete" mode.
        if editing == true {
            deleteSelectedPhotos()
        }
        // Non-editing (editing == false), is image selection mode. Image selection navigates to ImageDetail view.
        else {
            refreshPhotoCollection()
        }
    }

    
    // MARK: - Selectors
    func finishedDownloadingImages(notification: NSNotification) {
        refreshRemoveButton.enabled = true
    }
    
    
    // MARK: - Private (class-static) functions
    private func initializeView() {
        
        fetchedResultsController.delegate = self

        automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem = editButtonItem()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        collectionView.allowsMultipleSelection = true
        
        initializeMap()
        
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
    
    private func refreshPhotoCollection() {
        noImagesLabel.hidden = true
        refreshRemoveButton.enabled = false
        
        // Delete all photos
        if let photos = fetchedResultsController.fetchedObjects as? [Photo] {
            
            for photo in photos {
                coreDataStack.context.deleteObject(photo)
            }
            coreDataStack.save()
        }
        
        // Get a new collection of photos
        Client.sharedInstance.downloadPhotos(forPin: pin, completionHandler: { (result, error) in
            
            guard let result = result
                where result as! Bool == true else {
                    print("Refresh error: \(error)")
                    self.displayMessage(error, title: "Refresh Error")
                    return
            }
            
            // TODO: Consider adding a NSNotification to this class and the FlickrClient to communicate when all photo's are finished downloading instead of the completionHandler.
            dispatch_async(dispatch_get_main_queue(), {
                self.toggleNoImagesLabel()
            })
        })
    }
    
    private func toggleNoImagesLabel() {
        if let photos = self.pin.photos where photos.count == 0 {
            self.noImagesLabel.hidden = false
        }
    }
    
    private func deleteSelectedPhotos() {
        
        guard let selectedItems = collectionView.indexPathsForSelectedItems() else {
            displayMessage("Opps, something went wrong while trying to delete photos", title: "Huh?")
            return
        }
        
        for indexPath in selectedItems {
            if let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Photo {
                coreDataStack.context.deleteObject(photo)
            }
        }
        coreDataStack.save()
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
        return fetchedResultsController.sections?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = fetchedResultsController.sections![section]
        return section.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let Id = PhotoCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Id, forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        
        cell.updateCell(photo)
        
        cell.alpha = (cell.selected) ? 0.5 : 1.0
        
        return cell
        
    }
}


// MARK: - UICollectionViewDelegate
extension PhotoAlbumViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if editing {
            collectionView.cellForItemAtIndexPath(indexPath)!.alpha = 0.5
        } else {
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
            
            let selectedPhoto = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
            
            self.performSegueWithIdentifier(Constants.OpenPhotoDetail, sender: selectedPhoto)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if editing {
            collectionView.cellForItemAtIndexPath(indexPath)!.alpha = 1.0
        }
    }
}