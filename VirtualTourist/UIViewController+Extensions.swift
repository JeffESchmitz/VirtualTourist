//
//  UIViewController+Extensions.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/9/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    // Reference: displayMessage taken from Ash Furrow's FunctionalReactiveAwesome repo - https://github.com/ashfurrow/FunctionalReactiveAwesome/blob/master/FunctionalReactiveAwesome/UIViewController%2BExtensions.swift
    func displayMessage(message: String?, title: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK", style: .Default, handler:
            { [weak self] (_) -> Void in
                self?.navigationController?.popToRootViewControllerAnimated(true)
            })
        
        alert.addAction(ok)
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
