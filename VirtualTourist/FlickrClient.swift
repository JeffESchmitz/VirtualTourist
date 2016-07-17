//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/10/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
            FlickrParameterKeys.APIKey          : FlickrParameterValues.APIKey,
            FlickrParameterKeys.Format          : FlickrParameterValues.Format,
            FlickrParameterKeys.NoJsonCallback  : FlickrParameterValues.NoJsonCallback,
            FlickrParameterKeys.SafeSearch      : FlickrParameterValues.SafeSearch,
            FlickrParameterKeys.Extras          : FlickrParameterValues.ExtrasMediumURL,
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
            guard let result = result,
                photosDictionary = result[FlickrResponseKeys.PhotosDictionary] as? [String: AnyObject],
                photoArray = photosDictionary[FlickrResponseKeys.PhotoArray] as? [[String: AnyObject]],
                numberOfPhotoPages = photosDictionary[FlickrResponseKeys.Pages] else {
                    completionHandler(result: nil, error: "Unable to download photos. Check Pin location or network connection")
                    return
            }
            
            pin.pageNumber = numberOfPhotoPages as? NSNumber

            // If the number of photos returned from Flickr are less than default (21), update the number of photos per page to adjust for less images expected to be downloaded.
            if photoArray.count < Int(FlickrParameterValues.PerPage) {
                self.numberOfImagesToDownload = photoArray.count
            }
            
            for photoDictionary in photoArray {
                guard let urlString = photoDictionary[FlickrResponseKeys.MediumURL] as? String else {
                    print("Unable to locate photo URL")
                    continue
                }
                
                let photo = Photo(imageUrl: urlString, pin: pin, context: self.coreDataStack.context)
                
                self.downloadImage(forPhoto: photo, completionHandler: { (success, error) in
                    
                    if success {
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.coreDataStack.save()
                            print("self.numberOfImagesToDownload: \(self.numberOfImagesToDownload)")
                            self.numberOfImagesToDownload -= 1
                            if self.numberOfImagesToDownload == 0 {
                                NSNotificationCenter.defaultCenter().postNotificationName(Constants.AllFilesDownloaded, object: nil)
                                self.numberOfImagesToDownload = Int(FlickrParameterValues.PerPage)!
                            }
                        })
                    }
                })
            }
            
            completionHandler(result: true, error: nil)
        }
    }
    
    func downloadImage(forPhoto photo: Photo, completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        guard let imageUrl = photo.imageUrl else {
            print("No URL for photo: \(photo)")
            return
        }
        
        taskForGETMethodWithURLString(imageUrl) { (result, error) in
            if let error = error {
                print("Error getting image for photo. error: \(error.localizedDescription)")
                completionHandler(success: false, error: error)
            } else {
                
                if let result = result {

//                    // DEBUGGING: Save the file to disk to check if image was correct
//                    let fileName = (imageUrl as NSString).lastPathComponent
//                    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//                    let pathArray = [dirPath, fileName]
//                    let fileURL = NSURL.fileURLWithPathComponents(pathArray)!
//                    print(fileURL)
//                    // Save file
//                    NSFileManager.defaultManager().createFileAtPath(fileURL.path!, contents: result as! NSData, attributes: nil)
//                    // END DEBUGGING
                    
                    photo.imageData = result as? NSData
                    
                    completionHandler(success: true, error: nil)
                }
            }
        }
    }
}










