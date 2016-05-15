//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation
import UIKit

extension NetworkUdacity {
    
    func authenticateToUdacity(userAndPass: [String: String], completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        self.getSessionID(userAndPass) { (success, sessionID, errorString) in
            
            if success {
                
                // success! we have the sessionID!
                self.sessionID = sessionID
                
                completionHandlerForAuth(success: success, errorString: errorString)
            } else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        }
  
    }
    
    private func getSessionID(userAndPass: [String: String], completionHandlerForSession: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String: AnyObject] = [:]
        
        let jsonString = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(userAndPass[JSONBodyKeys.Username]!)\", \"\(JSONBodyKeys.Password)\": \"\(userAndPass[JSONBodyKeys.Password]!)\"} }"
        
        
        /* 2. Make the request */
        taskForPOSTMethod(Methods.Session, parameters: parameters, jsonBody: jsonString) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForSession(success: false, sessionID: nil, errorString: error.localizedDescription)
            } else {
                if let session = results[JSONResponseKeys.Session] as? [String: AnyObject],
                let account = results[JSONResponseKeys.Account] as? [String: AnyObject],
                    let sessionID = session[JSONResponseKeys.SessionID] as? String,
                    let userID = account[JSONResponseKeys.AccountKey] as? String{
                    
                    
                    self.userID = userID
                    
                    completionHandlerForSession(success: true, sessionID: sessionID, errorString: nil)
                } else {
                    print("Could not find \(JSONResponseKeys.SessionID) in \(results)")
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (Session ID). ")
                }
            }
            
        }
        
    }
    
    func logout(view: UIViewController, completionForLogout: ((success: Bool, errorString: String?) -> Void) ) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String: AnyObject] = [:]
        
        /* 2. Make the request */
        taskForDELETEMethod(Methods.Session, parameters: parameters) { (result, error) in

                if let error = error {
                    print(error)
                    completionForLogout(success: false, errorString: "Logout Failed (\(error.localizedDescription)).")
                }else{
                    completionForLogout(success: true, errorString: nil)
                    
                }
            
        }
    }
    
    func getUserData(completion: (success: Bool, userData: [String: AnyObject]?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String: AnyObject] = [:]

        /* 2. Make the request */
        
        let method = GeneralConnection.subtituteKeyInMethod(Methods.User, key: ParameterKeys.id, value: String(userID!))
        
        taskForGETMethod(method!, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completion(success: false, userData: nil, errorString: "Login Failed (Session ID). User or password incorrect")
            } else {
                if let user = results[JSONResponseKeys.User] as? [String: AnyObject],
                    let _firstName = user[JSONResponseKeys.FirstName] as? String,
                    let _lastName = user[JSONResponseKeys.LastName] as? String {
                        self.firstName = _firstName
                        self.lastName = _lastName
                        completion(success: true, userData: nil, errorString: nil)
                } else {
                    print("Could not find \(JSONResponseKeys.User) in \(results)")
                    completion(success: false, userData: nil, errorString: "failed to get data User.")
                }
            }
            
        }
        
    }
}
