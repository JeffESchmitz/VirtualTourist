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
        static let Pin              = "Pin"
        static let Photo            = "Photo"
        static let Title            = "title"
    }
    
}

extension Client {
    
    struct HttpRequest {
        static let MethodPOST               = "POST"
        static let AcceptHeaderField        = "Accept"
        static let ContentTypeHeaderField   = "Content-Type"
        static let ContentJSON              = "application/json"
        static let MethodGET                = "GET"
        
        static let MethodDELETE             = "DELETE"
        static let CookieName               = "XSRF-TOKEN"
        static let XSRFHeaderField          = "X-XSRF-TOKEN"
        
    }
    
    struct Components {
        static let scheme                   = "https"
        static let host                     = "api.flickr.com"
        static let path                     = "/services/rest"
    }
    
    struct Errors {
        static let domain                   = "APISession"
        static let unsuccessfulResponse     = "Unsuccessful response."
        static let noData                   = "No Data Returned from Request."
        static let noDataCode               = 1000
        static let unableToConverData       = "Could not parse the data as JSON"
        static let unableToConverDataCode   = 1001
    }
    
    struct FlickrParameterKeys {
        static let Method          = "method"
        static let APIKey          = "api_key"
        static let Format          = "format"
        static let NoJsonCallback  = "nojsoncallback"
        static let SafeSearch      = "safe_search"
        static let Extras          = "extras"
        static let Page            = "page"
        static let PerPage         = "per_page"
        static let Latitude        = "lat"
        static let Longitude       = "lon"

    }
    
    struct FlickrParameterValues {
        
        static let Method                   = "flickr.photos.search"
        static let APIKey_Somewhere_Else    = "4120b4b57e0c20e206965d809d8d59e4"
        static let APIKey                   = "f1aeaeb551dde21a0cecb995ea5ac07f"
        static let Format                   = "json"
        static let NoJsonCallback           = "1"
        static let SafeSearch               = "1"
//        static let Extras                   = "url_c"
        static let ExtrasMediumURL          = "url_m"
        static let PerPage                  = "21"
        
    }
    
    struct FlickrResponseKeys {
        static let Status           = "stat"
        static let Code             = "code"
        static let Message          = "message"
        static let PhotosDictionary = "photos"
        static let PhotoArray       = "photo"
        static let Pages            = "pages"
        static let MediumURL        = "url_m"
    }
    
    struct FlickrResponseValues {
        static let Ok               = "ok"
        static let Fail             = "fail"
    }
}













