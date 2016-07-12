//
//  Client.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/11/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation

class Client {
    
    static let sharedInstance = Client()
    var session: NSURLSession
    
    private init() {
        session = NSURLSession.sharedSession()
        
    }
    
    func taskForGETMethod(url: NSURL, headers: [String:String]? = nil,
                          completionHandler: (result: AnyObject!, error: NSError?) -> Void) {

        // Create a request and default HTTPMethod to GET
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = Client.HttpRequest.MethodGET
        
        // Add the sent headers to the request
        if let headers = headers {
            for (key, value)  in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        print("allHTTPHeaderFields: \(request.allHTTPHeaderFields)")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // Check if any errors happened
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }

            // Successful 2XX response?
            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode < 200 && statusCode > 299 {
                let userInfo = [
                    NSLocalizedDescriptionKey: Errors.unsuccessfulResponse
                ]
                let error = NSError(domain: Errors.domain, code: statusCode, userInfo: userInfo)
                completionHandler(result: nil, error: error)
                return
            }

            // Any data returned?
            guard let data = data else {
                let userInfo = [
                    NSLocalizedDescriptionKey: Errors.noData
                ]
                let error = NSError(domain: Errors.domain, code: Errors.noDataCode, userInfo: userInfo)
                completionHandler(result: nil, error: error)
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
        }
        
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
    
}