//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation

extension ParseConnection {
    
    func getStudentLocationsFromParse(completionHandler: (result: [StudentLocation]!, errorString: String?) -> Void) {
        getStudentLocations { (success, locations, errorString) in
            if success {
                if !locations!.isEmpty {
                    completionHandler(result: locations, errorString: nil)
                    return
                }else {
                    completionHandler(result: nil, errorString: "No hay estudiantes.")
                    return
                }
                
            }else {
                completionHandler(result: nil, errorString: errorString)
            }
        }
    }
    
    private func getStudentLocations( completionHandlerForLocations: (success: Bool, locations: [StudentLocation]?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters: [String: AnyObject] = [:]
        parameters["limit"] = 100
        /* 2. Make the request */
        taskForGETMethodParse(ParseConnection.Methods.StudentLocations, parameters: parameters) { (result, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForLocations(success: false, locations: nil, errorString: "No se pudo obtener Estudiantes.")
            } else {

                if let students = result[JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    let studentsArray = StudentLocation.studentFromResults(students)
                    completionHandlerForLocations(success: true, locations: studentsArray, errorString: nil)
                    return
                }else{
                    completionHandlerForLocations(success: false, locations: nil, errorString: nil)
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
                print(error)
                completionForGetLocation(success: false, location: nil, errorString: "Error: No se pudo obtener Ubicación.")
            } else {
                
                if let student = result[JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    
                    let studentLocation = StudentLocation(dictionary: student.first!)
                    completionForGetLocation(success: true, location: studentLocation, errorString: nil)
                    return
                }else{
                    completionForGetLocation(success: false, location: nil, errorString: "Not found (failed to cast)")
                    return
                }
                
            }
        }
        
    }
    
    func updateStudentLocation( studentLocation: StudentLocation, completionforUpdate: (success: Bool, errorString: String?) -> Void ) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters: [String: AnyObject] = [:]
        parameters["where"] = "{\"\(ParameterKeys.UniqueKey)\": \"\(NetworkUdacity.sharedInstance().userID!)\"}"
        /* 2. Make the request */
        taskForGETMethodParse(ParseConnection.Methods.StudentLocations, parameters: parameters) { (result, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionforUpdate(success: false, errorString: "Error: No se pudo obtener Ubicación.")
            } else {
                
                if result != nil {
                    completionforUpdate(success: true, errorString: nil)
                    return
                }else{
                    completionforUpdate(success: false, errorString: "Not found (failed to cast)")
                    return
                }
                
            }
        }
    }
}