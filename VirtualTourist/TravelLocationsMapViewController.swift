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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TravelLocationsMapViewController.showEditing(_:)))
        navigationItem.rightBarButtonItem = rightButton
        deletePinsLabel.hidden = true
    }
    
    func showEditing(sender: UIBarButtonItem)
    {
        setEditing(!editing, animated: true)
        if editing == true {
            deletePinsLabel.hidden = false
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            deletePinsLabel.hidden = true
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
        
    }
}