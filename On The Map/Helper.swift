//
//  Helper.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit

class Helper {
    
    class func presentAlert(view: UIViewController, title: String, message: String) {
        
        let alertView = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert
        )
        
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertView.addAction(okButton)
        
        view.presentViewController(alertView, animated: true, completion: nil)
    }
}