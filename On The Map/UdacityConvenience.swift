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
                
//                self.getUserID() { (success, userID, errorString) in
//                    
//                    if success {
//                        
//                        if let userID = userID {
//                            
//                            // and the userID 😄!
//                            self.userID = userID
//                        }
//                    }
//                    
//                    completionHandlerForAuth(success: success, errorString: errorString)
//                }
            } else {
                completionHandlerForAuth(success: success, errorString: errorString!)
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
                print(error)
                completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
            } else {
                if let session = results[JSONResponseKeys.Session] as? [String: AnyObject],
                    let sessionID = session[JSONResponseKeys.SessionID] as? String {
                    
                    completionHandlerForSession(success: true, sessionID: sessionID, errorString: nil)
                } else {
                    print("Could not find \(JSONResponseKeys.SessionID) in \(results)")
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
                }
            }
            
        }
        
    }
}
