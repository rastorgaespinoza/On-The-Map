//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation

extension ParseConnection {
    
    func getStudentLocations( completionHandlerForLocations: (locationsResult: [StudentLocation]!, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters: [String: AnyObject] = [:]
        parameters["limit"] = 100
        parameters["order"] = "-updatedAt" 
        /* 2. Make the request */
        taskForGETMethodParse(ParseConnection.Methods.StudentLocations, parameters: parameters) { (result, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLocations(locationsResult: nil, errorString: "\(error.localizedDescription)")
            } else {

                if let students = result[JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    let studentsArray = StudentLocation.studentFromResults(students)
                    completionHandlerForLocations(locationsResult: studentsArray, errorString: nil)
                    return
                }else{
                    completionHandlerForLocations(locationsResult: nil, errorString: "Could not parse the data as JSON in result")
                    return
                }

            }
        }
    }
    
    func getStudentLocationForUser( completionForGetLocation: (success: Bool, location: StudentLocation?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters: [String: AnyObject] = [:]
        parameters["where"] = "{\"\(ParameterKeys.UniqueKey)\": \"\(NetworkUdacity.sharedInstance().userID!)\"}"
        /* 2. Make the request */
        taskForGETMethodParse(ParseConnection.Methods.StudentLocations, parameters: parameters) { (result, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionForGetLocation(success: false, location: nil, errorString: error.localizedDescription)
            } else {
                
                if let student = result[JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    
                    let studentLocation = StudentLocation(dictionary: student.first!)
                    self.objectId = studentLocation.objectId
                    completionForGetLocation(success: true, location: studentLocation, errorString: nil)
                    return
                }else{
                    completionForGetLocation(success: false, location: nil, errorString: "Not found (failed to cast)")
                    return
                }
                
            }
        }
        
    }
    
    func postStudentLocation( studentLocationData: [String: AnyObject], completionforPost: (success: Bool, errorString: String?) -> Void ) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String: AnyObject] = [:]

        let jsonBody: String = "{\"\(JSONResponseKeys.UniqueKey)\"=\"\(studentLocationData[JSONResponseKeys.UniqueKey]!)\", \"\(JSONResponseKeys.FirstName)\"=\"\(studentLocationData[JSONResponseKeys.FirstName]!)\",\"\(JSONResponseKeys.LastName)\"=\"\(studentLocationData[JSONResponseKeys.LastName]!)\",\"\(JSONResponseKeys.Latitude)\"=\(studentLocationData[JSONResponseKeys.Latitude]!),\"\(JSONResponseKeys.Longitude)\"=\(studentLocationData[JSONResponseKeys.Longitude]!), \"\(JSONResponseKeys.MapString)\"=\"\(studentLocationData[JSONResponseKeys.MapString]!)\",\"\(JSONResponseKeys.MediaURL)\"=\"\(studentLocationData[JSONResponseKeys.MediaURL]!)\"}"
        
        /* 2. Make the request */
        taskForPOSTMethodParse(Methods.StudentLocations, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionforPost(success: false, errorString: error.localizedDescription)
            } else {
                
                if result != nil {
                    completionforPost(success: true, errorString: nil)
                    return
                }else{
                    completionforPost(success: false, errorString: "Not found (failed to cast)")
                    return
                }
                
            }
        }

    }
    
    
    func updateStudent( studentLocationData: [String: AnyObject], completionForUpdate: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String: AnyObject] = [:]

        /* 2. Make the request */
        let method = Methods.StudentLocations + "/\(studentLocationData[JSONResponseKeys.ObjectID]!)"
        taskForPUTMethodParse(method, parameters: parameters, jsonBody: studentLocationData) { (result, error) in
            if error != nil {
                completionForUpdate(success: false, errorString: error!.localizedDescription)
            }else{
                if let result = result as? [String: AnyObject] {
                    completionForUpdate(success: true, errorString: nil)
                }else{
                    completionForUpdate(success: false, errorString: "Not found (failed to cast)")
                }
            }
        }
    }
    
    
}