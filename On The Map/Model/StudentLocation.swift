//
//  StudentLocation.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var objectId: String = ""
    var uniqueKey: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var mapString: String = ""
    var mediaURL: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    init(dictionary: [String: AnyObject]) {
        objectId = (dictionary[ParseConnection.JSONResponseKeys.ObjectID] as? String)!
        uniqueKey = (dictionary[ParseConnection.JSONResponseKeys.UniqueKey] as? String)!
        firstName = (dictionary[ParseConnection.JSONResponseKeys.FirstName] as? String)!
        lastName = (dictionary[ParseConnection.JSONResponseKeys.LastName] as? String)!
        mapString = (dictionary[ParseConnection.JSONResponseKeys.MapString] as? String)!
        mediaURL = (dictionary[ParseConnection.JSONResponseKeys.MediaURL] as? String)!
        latitude = (dictionary[ParseConnection.JSONResponseKeys.Latitude] as? Double)!
        longitude = (dictionary[ParseConnection.JSONResponseKeys.Longitude] as? Double)!
    }

    // Create an array of Students
    static func studentFromResults(results: [[String: AnyObject]]) -> [StudentLocation] {
        var students = [StudentLocation]()
        for result in results {
            let stu = StudentLocation(dictionary: result)
            if stu.firstName != "nil" {
                students.append(stu)
            }
        }
        return students
    }
    
}