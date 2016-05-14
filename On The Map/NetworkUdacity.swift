//
//  NetworkUdacity.swift
//  On The Map
//
//  Reutilización de TMDBClient.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import Foundation

// MARK: - NetworkUdacity: NSObject

class NetworkUdacity : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // authentication state
    var sessionID : String? = nil
    var userID : String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    func taskForGETMethod(method: String, parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let newParameters = parameters
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let url = udacityURLFromParameters(newParameters, withPathExtension: method)
        let request = NSMutableURLRequest(URL: url)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* 5/6. Check data. Then, Parse the data and use the data (happens in completion handler) */
            GeneralConnection.validateData(TypeOfClient.Udacity, method: "taskForGETMethod", data: data, response: response, error: error, completionData: completionHandlerForGET)

        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let newParameters = parameters
        /* 1. Set the parameters */
        /* 2/3. Build the URL, Configure the request */

        let request = NSMutableURLRequest(URL: udacityURLFromParameters(newParameters, withPathExtension: method))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            GeneralConnection.validateData(TypeOfClient.Udacity, method: "taskForPOSTMethod", data: data, response: response, error: error, completionData: completionHandlerForPOST)

        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    func taskForDELETEMethod(method: String, parameters: [String:AnyObject], completionHandlerForDELETE: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* 1. Set the parameters */
        let newParameters = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(newParameters, withPathExtension: method))
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            GeneralConnection.validateData(TypeOfClient.Udacity, method: "taskForDELETEMethod", data: data, response: response, error: error, completionData: completionHandlerForDELETE)

        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // create a URL from parameters
    private func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = NetworkUdacity.Constants.ApiScheme
        components.host = NetworkUdacity.Constants.ApiHost
        components.path = NetworkUdacity.Constants.ApiPath + (withPathExtension ?? "")
        
        
        if !parameters.isEmpty {
            components.queryItems = [NSURLQueryItem]()
            for (key, value) in parameters {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }

        return components.URL!
    }
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> NetworkUdacity {
        struct Singleton {
            static var sharedInstance = NetworkUdacity()
        }
        return Singleton.sharedInstance
    }
}
