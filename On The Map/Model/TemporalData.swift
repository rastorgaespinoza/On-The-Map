//
//  TemporalData.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation

class TemporalData {
    
    private var _students: [StudentLocation] = []
    
    var students: [StudentLocation] {
        get {
            return _students
        }
        set {
            _students = newValue
        }
    }
    
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> TemporalData {
        struct Singleton {
            static var sharedInstance = TemporalData()
        }
        return Singleton.sharedInstance
    }
    
}
