//
//  ParseConnection.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation

class ParseConnection: NSObject {
    
    // MARK: Properties
    var objectId: String = ""
    // shared session
    var session = NSURLSession.sharedSession()

    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // MARK: GET
    func taskForGETMethodParse(method: String, parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let newParameters = parameters
        /* 1. Set the parameters */
        //en este caso no se setean parametros...
        
        /* 2/3. Build the URL, Configure the request */
        let url = parseURLFromParameters(newParameters, withPathExtension: method)

        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.AppID, forHTTPHeaderField: HTTPHeaders.ParseAPPID)
        request.addValue(Constants.RestApiKey, forHTTPHeaderField: HTTPHeaders.ParseRestAPIKey)
        

        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            GeneralConnection.validateData(TypeOfClient.Parse, method: "taskForGETMethodParse", data: data, response: response, error: error, completionData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethodParse(method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let newParameters = parameters
        /* 1. Set the parameters */
        /* 2/3. Build the URL, Configure the request */
        let url = parseURLFromParameters(newParameters, withPathExtension: method)

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(ParseConnection.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseConnection.Constants.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            GeneralConnection.validateData(TypeOfClient.Parse, method: "taskForPOSTMethodParse", data: data, response: response, error: error, completionData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    //MARK: PUT
    func taskForPUTMethodParse(method: String, parameters: [String:AnyObject], jsonBody: [String: AnyObject], completionHandlerForPUT: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let newParameters = parameters
        /* 1. Set the parameters */
        //en este caso no se setean parametros...
        
        /* 2/3. Build the URL, Configure the request */
        let url = parseURLFromParameters(newParameters, withPathExtension: method)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(ParseConnection.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseConnection.Constants.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if NSJSONSerialization.isValidJSONObject(jsonBody) {
            do{
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
            }catch {
                print("error to convert object to NSData (NSSerialization)")
            }
        }else{
            request.HTTPBody = nil
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            GeneralConnection.validateData(TypeOfClient.Parse, method: "taskForPUTMethodParse", data: data, response: response, error: error, completionData: completionHandlerForPUT)
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // create a URL from parameters
    private func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        
        
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
    
    class func sharedInstance() -> ParseConnection {
        struct Singleton {
            static var sharedInstance = ParseConnection()
        }
        return Singleton.sharedInstance
    }
}