//
//  TabBarController.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 07-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let pConnection: ParseConnection = ParseConnection.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pinAction(sender: AnyObject) {
        print("se presionó sobre el botón pin")
        pConnection.getStudentLocationForUser { (success, location, errorString) in
            dispatch_async(dispatch_get_main_queue() ) {
                if success {
                    print("se encontró usuario")
                    let alertVC = UIAlertController(
                        title: nil, message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .Alert)
                    
                    let overwriteButton = UIAlertAction(title: "Overwrite ", style: .Default, handler: { (action) in
                        print("se desea sobreescribir")
                        self.presentInformationPostingView()
                    })
                    
                    let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    
                    alertVC.addAction(overwriteButton)
                    alertVC.addAction(cancel)
                    
                    self.presentViewController(alertVC, animated: true, completion: nil)
                    
                }else{
                    print(errorString!)
                    self.presentInformationPostingView()
                }
            }
            
        }
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        pConnection.getStudentLocationsFromParse { (result, errorString) in
            if let result = result {
                TemporalData.sharedInstance().students = result
            }else {
                print(errorString!)
            }
        }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        NetworkUdacity.sharedInstance().logout(self) { (success, errorString) in
            dispatch_async(dispatch_get_main_queue()) {
                if success {
                    NetworkUdacity.sharedInstance().sessionID = nil
                    NetworkUdacity.sharedInstance().userID = nil
                    
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC")
                    self.presentViewController(loginVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func presentInformationPostingView() {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("InfoPostVC") as! InformationPostingViewController
        presentViewController(controller, animated: true, completion: nil)
    }


}
