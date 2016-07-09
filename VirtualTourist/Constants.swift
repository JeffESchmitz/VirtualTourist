//
//  Constants.swift
//  VirtualTourist
//
//  Created by Jeff Schmitz on 7/8/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

// MARK: Constants accross all clients
struct Constants {
    
    static let MapLatitude          = "MapLatitude"
    static let MapLongitude         = "MapLongitude"
    static let MapLatitudeDelta     = "MapLatitudeDelta"
    static let MapLongitudeDelta    = "MapLongitudeDelta"
    
    static let DataModelName        = "VirtualTourist"
    static let Latitude             = "latitude"
    static let Longitude            = "longitude"

    
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
        
        static let Method           = "flickr.photos.search"
        static let APIKey           = "4120b4b57e0c20e206965d809d8d59e4"
        static let ResponseFormat   = "json"

    }

    
}

