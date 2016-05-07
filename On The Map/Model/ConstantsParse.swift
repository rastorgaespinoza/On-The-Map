//
//  ConstantsParse.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation

extension ParseConnection {
    
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1"
        static let PathForStudents = "/1/classes/StudentLocation"
        
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    // MARK: Methods
    struct Methods {
        static let StudentLocations = "/classes/StudentLocation"
    }
    
    struct HTTPHeaders {
        static let ParseAPPID = "X-Parse-Application-Id"
        static let ParseRestAPIKey = "X-Parse-REST-API-Key"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let SessionID = "session_id"
        static let UserID = "userID"
        static let UniqueKey = "uniqueKey"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {

        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        
        // MARK: Get User Data
        static let User = "user"
        
    }
    
}