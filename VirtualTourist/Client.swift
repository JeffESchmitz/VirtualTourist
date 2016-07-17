//
//  Client.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/11/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Client {
    
    static let sharedInstance = Client()
    var session: NSURLSession
    let coreDataStack: CoreDataStack
    var numberOfImagesToDownload: Int
    
    private init() {
        session = NSURLSession.sharedSession()
        coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        numberOfImagesToDownload = Int(FlickrParameterValues.PerPage)!
    }

    func taskForGETMethod(withRequest request: NSMutableURLRequest,
                                        completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        // Go get the JSON, k?
        taskForGetInternal(request, parseJSON: true, completionHandler: completionHandler)
    }
    
    func taskForGETMethodWithParameters(parameters: [String : AnyObject],
                                        completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        let url = buildURL(withParmeters: parameters)
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        
        // Go get the JSON, k?
        taskForGetInternal(request, parseJSON: true, completionHandler: completionHandler)
    }
    
    func taskForGETMethodWithURLString(urlString: String,
                                       completionHandler: (result: AnyObject!, error: NSError?) -> Void) {

        guard !urlString.isEmpty else {
            print("urlString is empty")
            return
        }

        // Create the request
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        // Get an Image
        taskForGetInternal(request, completionHandler: completionHandler)
    }
    
    private func taskForGetInternal(request: NSMutableURLRequest,
                                    parseJSON: Bool = false,
                                    completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
     
        // Generate the task
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Check if any errors happened
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if parseJSON {
                self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandler)
            } else {
                completionHandler(result: data, error: error)
            }
        }
        
        // Execute the task
        task.resume()

    }
    
    private func convertDataWithCompletionHandler(data: NSData,
                                                  completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : Errors.unableToConverData]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: Errors.unableToConverDataCode, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }

    private func buildURL(withParmeters parameters: [String: AnyObject]) -> NSURL {
        
        let urlComponents           = NSURLComponents()
        urlComponents.scheme        = Components.scheme
        urlComponents.host          = Components.host
        urlComponents.path          = Components.path
        urlComponents.queryItems    = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let stringValue = "\(value)"
            let element = NSURLQueryItem(name: key, value: stringValue)
            urlComponents.queryItems?.append(element)
        }
        
        return urlComponents.URL!
    }
}