//
//  GeneralConnection.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 08-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//
//class for Helpers
//functions used by any of the clients. They are independent of the client, therefore, they can be used both "Parse" as "Udacity"
//

import Foundation


class GeneralConnection {
    
    // given raw JSON, return a usable Foundation object
    class func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    
    //check data for task
    class func validateData( client: TypeOfClient, method: String, data: NSData?, response: NSURLResponse?, error: NSError?, completionData: (result: AnyObject!, error: NSError?) -> Void) {
        func sendError(error: String) {
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionData(result: nil, error: NSError(domain: method, code: 1, userInfo: userInfo))
        }
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            sendError("There was an error with your request: \(error!.localizedDescription)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            print((response as? NSHTTPURLResponse)?.statusCode)
            if (response as? NSHTTPURLResponse)?.statusCode >= 401 && (response as? NSHTTPURLResponse)?.statusCode <= 403 {
                sendError("Invalid Username or Password!")
            }else{
                sendError("Your request returned a status code other than 2xx!")
            }
            
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            sendError("No data was returned by the request!")
            return
        }
        
        /* 5/6. Parse the data and use the data (happens in completion handler) */
        switch client {
            
        //SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE FROM THE UDACITY API
        case .Udacity:
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionData)
        default:
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionData)
        }

    }
    
    // substitute the key for the value that is contained within the method name
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
}

enum TypeOfClient: String {
    case Udacity
    case Parse
}