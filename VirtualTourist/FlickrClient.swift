//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/10/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation

extension Client {
    
    
    func downloadPhotos(forPin pin: Pin,
                               completionHandler: (result: AnyObject!, error: String?) -> Void) {
        
        var randomPage = 1
        
        if let pageNumber = pin.pageNumber?.integerValue where pageNumber > 0 {
            let pageLimit = min(pageNumber, 20)
            randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
        }
        
        let requestParameters: [String : AnyObject] = [
            FlickrParameterKeys.Method          : FlickrParameterValues.Method,
            FlickrParameterKeys.Method          : FlickrParameterValues.Method,
            FlickrParameterKeys.APIKey          : FlickrParameterValues.APIKey,
            FlickrParameterKeys.Format          : FlickrParameterValues.Format,
            FlickrParameterKeys.NoJsonCallback  : FlickrParameterValues.NoJsonCallback,
            FlickrParameterKeys.SafeSearch      : FlickrParameterValues.SafeSearch,
            FlickrParameterKeys.Extras          : FlickrParameterValues.Extras,
            FlickrParameterKeys.Page            : randomPage,
            FlickrParameterKeys.PerPage         : FlickrParameterValues.PerPage,
            FlickrParameterKeys.Latitude        : Double(pin.latitude!),
            FlickrParameterKeys.Longitude       : Double(pin.longitude!)
        ]


        taskForGETMethodWithParameters(requestParameters) { (result, error) in
            
            guard error == nil  else {
                completionHandler(result: nil, error: error?.localizedDescription)
                return
            }
            
            // Get them-there photos y'all
            
        }
    }
    
    
//    var randomPageNumber: Int {
//        get {
//            if let totalPages =
//        }
//    }
}