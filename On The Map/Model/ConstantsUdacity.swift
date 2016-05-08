//
//  ConstantsUdacity.swift
//  On The Map
//
//  Modification of TMDBConstants.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15. (Modified)
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

// MARK: - NetworkUdacity (Constants)

extension NetworkUdacity {
    
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: Methods
    struct Methods {
        static let Session = "/session"
        static let User = "/users/{id}"
        
    }

    // MARK: Parameter Keys
    struct ParameterKeys {
        static let SessionID = "session_id"
        static let UserID = "userID"
        static let id = "id"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Create a session
        static let Account = "account"
        static let AccountRegistered = "registered"
        static let AccountKey = "key"
        static let Session = "session"
        static let SessionID = "id"
        
        // MARK: Get User Data
        static let User = "user"
        
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
    }
    
}
