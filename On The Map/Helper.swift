//
//  Helper.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit
import MapKit

class Helper {
    
    class func presentAlert(view: UIViewController, title: String?, message: String?) {
        
        let alertView = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert
        )
        
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertView.addAction(okButton)
        
        
        view.presentViewController(alertView, animated: true, completion: nil)
        alertView.view.layoutIfNeeded()
    }
    
    class func openURL(view: UIViewController, urlString: String) {
        let app = UIApplication.sharedApplication()
        
        if let url = NSURL(string: urlString) {
            if !app.openURL(url) {
                Helper.presentAlert(view, title: "error to open safari", message: "Not valid URL")
            }
        }else{
            Helper.presentAlert(view, title: "error to open safari", message: "Not valid URL")
        }
    }
}
