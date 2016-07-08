//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/6/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deletePinsLabel: UILabel!
    
//    var droppedPin: Pin!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = editButtonItem()

        navigationItem.rightBarButtonItem = rightButton
        deletePinsLabel.hidden = true
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
}