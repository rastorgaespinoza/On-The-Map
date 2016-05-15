//
//  TabBarController.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 07-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit

let startRefreshNotif = "com.rastorga.startRefreshKey"
let stopRefreshNotif = "com.rastorga.stopRefreshKey"

class TabBarController: UITabBarController {

    let pConnection: ParseConnection = ParseConnection.sharedInstance()
    var customPopoverMaskView: UIView!
    var activityIndicator: UIActivityIndicatorView! = nil
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        
        NetworkUdacity.sharedInstance().getUserData { (success, userData, errorString) in
            dispatch_async(dispatch_get_main_queue() ) {
                if success {
                }else{
                    Helper.presentAlert(self, title: "Error:", message: errorString!)
                }
            }
            
        }
    }
    
    @IBAction func pinAction(sender: AnyObject) {
        startRefresh()
        pConnection.getStudentLocationForUser { (success, location, errorString) in
            dispatch_async(dispatch_get_main_queue() ) {
                self.stopRefresh()
                if success {

                    let alertVC = UIAlertController(
                        title: nil, message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .Alert)
                    
                    let overwriteButton = UIAlertAction(title: "Overwrite ", style: .Default, handler: { (action) in
                        
                        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("InfoPostVC") as! InformationPostingViewController
                        controller.objectId = location!.objectId
                        self.presentViewController(controller, animated: true, completion: nil)
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
        NSNotificationCenter.defaultCenter().postNotificationName(startRefreshNotif, object: self)
        pConnection.getStudentLocations { (result, errorString) in
            dispatch_async(dispatch_get_main_queue() ) {
                
                if let result = result {
                    TemporalData.sharedInstance().students = result
                }else {
                    Helper.presentAlert(self, title: "Error:", message: errorString!)
                }
                NSNotificationCenter.defaultCenter().postNotificationName(stopRefreshNotif, object: self)
            }
        }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        startRefresh()
        NetworkUdacity.sharedInstance().logout(self) { (success, errorString) in
            dispatch_async(dispatch_get_main_queue()) {
                self.stopRefresh()
                if success {
                    NetworkUdacity.sharedInstance().sessionID = nil
                    NetworkUdacity.sharedInstance().userID = nil
                    
                    TemporalData.sharedInstance().students.removeAll()
                    let loginVC = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC")
                    self.presentViewController(loginVC, animated: true, completion: nil)
                }else{
                    Helper.presentAlert(self, title: "Error:", message: errorString!)
                }
            }
        }
    }
    
    func presentInformationPostingView() {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("InfoPostVC") as! InformationPostingViewController
        presentViewController(controller, animated: true, completion: nil)
    }


}

extension TabBarController {
    
    func startRefresh() {
        //add activityIndicator...
        
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        view.userInteractionEnabled = false
        logoutButton.enabled = false
        pinButton.enabled = false
        refreshButton.enabled = false
        customPopoverMaskView = UIView(frame: CGRectMake(0,0, view.bounds.size.width, view.bounds.size.height ) )
        customPopoverMaskView.backgroundColor = UIColor.blackColor()
        customPopoverMaskView.alpha = 0.3
        customPopoverMaskView.userInteractionEnabled = false
        
        UIView.transitionWithView(view, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.view.addSubview(self.customPopoverMaskView)
            self.view.addSubview(self.activityIndicator)
            }, completion: { _ in
                
        })
        
    }
    
    func stopRefresh() {
        //end activityIndicator...
        activityIndicator.stopAnimating()
        view.userInteractionEnabled = true
        logoutButton.enabled = true
        pinButton.enabled = true
        refreshButton.enabled = true
        UIView.transitionWithView(view, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.customPopoverMaskView.removeFromSuperview()
            self.activityIndicator.removeFromSuperview()
            }, completion: { _ in
                
        })

    }
    
}

protocol CommonOperations: AnyObject {
    func refresh(sender: AnyObject)
}
