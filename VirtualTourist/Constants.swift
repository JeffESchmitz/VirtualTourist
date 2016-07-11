//
//  Constants.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/8/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//
import UIKit

// MARK: Constants accross application
struct Constants {
    
    static let MapLatitude          = "MapLatitude"
    static let MapLongitude         = "MapLongitude"
    static let MapLatitudeDelta     = "MapLatitudeDelta"
    static let MapLongitudeDelta    = "MapLongitudeDelta"
    
    static let DataModelName        = "VirtualTourist"
    static let Latitude             = "latitude"
    static let Longitude            = "longitude"

    static let MapReuseId           = "Pin"
    
    static let OpenPhotoAlbum       = "OpenPhotoAlbum"
    
    struct ColorPalette {
        static let UdacityBlue = UIColor(red:0.01, green:0.70, blue:0.89, alpha:1.0)

    }
    
    struct Entity {
        static let Pin      = "Pin"
        static let Photo    = "Photo"
        static let Title    = "title"
    }
    
    struct HttpRequest {
        static let MethodPOST               = "POST"
        static let AcceptHeaderField        = "Accept"
        static let ContentTypeHeaderField   = "Content-Type"
        static let ContentJSON              = "application/json"
        
        static let MethodDELETE             = "DELETE"
        static let CookieName               = "XSRF-TOKEN"
        static let XSRFHeaderField          = "X-XSRF-TOKEN"
        
    }
    
    struct FlickrParameterKeys {
        static let Method       = "method"
        static let APIKey       = "api_key"
        static let GalleryID    = "gallery_id"

    }
    
    struct FlickrParameterValues {
        
        static let Method                       = "flickr.photos.search"
        static let APIKey_Somewhere_Else        = "4120b4b57e0c20e206965d809d8d59e4"
        static let APIKey_jeffschmitz           = "f1aeaeb551dde21a0cecb995ea5ac07f"
        
        static let ResponseFormat   = "json"

    }

    
}

extension FlickrClient {
    
    // MARK: Components
    
    struct Components {
        static let scheme = "https"
        static let host = "api.flickr.com"
        static let path = "/services/rest"
    }
}

