//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 07-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    let pConection: ParseConnection = ParseConnection.sharedInstance()
    
    //Varibales for posting location
    var data = [String:AnyObject]()
    var objectId: String?
    var lat:Double?
    var long:Double?
    var address: String?
    var url: String?
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var findMapSubmit: UIButton!
    @IBOutlet weak var linkToShare: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topInitialView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapActivityIndicator: UIActivityIndicatorView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        findMapSubmit.layer.cornerRadius = 10
        submit.layer.cornerRadius = 10
        submitView.layer.cornerRadius = 10
        configureTextField(linkToShare)
        configureTextField(locationText)
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func findOnTheMap(sender: AnyObject) {
        guard let location = locationText.text where !location.isEmpty else {
            Helper.presentAlert(self, title: nil, message: "Must Enter a Location.")
            return
        }
        
        view.endEditing(true)
        activityIndicator.startAnimating()
        setUIEnabled(false)
        //retrieved from Stackoverflow: "How to get lat and long coordinates from address string"
        //url: http://stackoverflow.com/questions/18563084/how-to-get-lat-and-long-coordinates-from-address-string
        //answered Dec 16 '15 at 5:26 from Vijay Singh Rana

        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.setUIEnabled(true)
                if let placemarks = placemarks where (placemarks.count > 0) {
                    self.changeView()
                    let topResult: CLPlacemark = placemarks.first!
                    let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                    var region: MKCoordinateRegion = self.mapView.region
                    region.center = placemark.coordinate
                    region.span.longitudeDelta /= 8.0
                    region.span.latitudeDelta /= 8.0
                    
                    self.lat = placemark.location!.coordinate.latitude
                    self.long = placemark.location!.coordinate.longitude
                    self.address = location
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.addAnnotation(placemark)
                }else{
                    Helper.presentAlert(self, title: nil, message: "No se encontró ubicación.")
                }
            }
        }
    
    }
    
    @IBAction func submit(sender: AnyObject) {

        guard let link = linkToShare.text where (!link.isEmpty) else {
            Helper.presentAlert(self, title: nil, message: "Must Enter a Link.")
            return
        }
        view.endEditing(true)
        url = link
        saveStudentLocation()
        
    }
    
    func saveStudentLocation(){
        setUIEnabled(false)
        mapActivityIndicator.startAnimating()
        
        var data: [String: AnyObject] = [
            ParseConnection.ParameterKeys.UniqueKey: NetworkUdacity.sharedInstance().userID!,
            ParseConnection.JSONResponseKeys.FirstName: NetworkUdacity.sharedInstance().firstName!,
            ParseConnection.JSONResponseKeys.LastName: NetworkUdacity.sharedInstance().lastName!,
            ParseConnection.JSONResponseKeys.MapString: address!,
            ParseConnection.JSONResponseKeys.MediaURL: url!,
            ParseConnection.JSONResponseKeys.Latitude: lat!,
            ParseConnection.JSONResponseKeys.Longitude: long!
        ]
  
        
        if let objectId = objectId {
            data[ParseConnection.JSONResponseKeys.ObjectID] = objectId
            pConection.updateStudent(data, completionForUpdate: { (success, errorString) in
                dispatch_async(dispatch_get_main_queue() ) {
                
                    self.mapActivityIndicator.stopAnimating()
                    self.setUIEnabled(true)
                    if success {
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        let navC = self.presentingViewController as! UINavigationController
                        
                        if let tabBarVC = navC.viewControllers.first as? TabBarController {
                            tabBarVC.refreshAction(self)
                        }
                    }else{
                        Helper.presentAlert(self, title: "Error:", message: errorString!)
                    }
                }
            })
        }else{
            pConection.postStudentLocation(data) { (success, errorString) in
                dispatch_async(dispatch_get_main_queue() ) {
                    self.mapActivityIndicator.stopAnimating()
                    self.setUIEnabled(true)
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        let navC = self.presentingViewController as! UINavigationController
                        
                        if let tabBarVC = navC.viewControllers.first as? TabBarController {
                            tabBarVC.refreshAction(self)
                        }
                    }else{
                        Helper.presentAlert(self, title: "Error:", message: errorString!)
                    }
                }
            }
        }
        
        
    }
    
    
    
}

extension InformationPostingViewController: UITextFieldDelegate {
    private func setUIEnabled(enabled: Bool){
        centerView.userInteractionEnabled = enabled
        bottomView.userInteractionEnabled = enabled
        if enabled {
            findMapSubmit.alpha = 1
            submit.alpha = 1
            submit.enabled = enabled
        }else{
            findMapSubmit.alpha = 0.5
            submit.alpha = 0.5
            submit.enabled = enabled
        }
    }
    
    func changeView() {
        centerView.hidden = true
        topInitialView.hidden = true
        findMapSubmit.hidden = true

        submitView.hidden = false
        bottomView.alpha = 0.5

        buttonCancel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        topView.backgroundColor = UIColor(red: 63/255, green: 116/255, blue: 167/255, alpha: 1)

        
    }
    
    private func configureTextField(textField: UITextField) {
        let textFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .Always
        textField.textColor = UIColor.whiteColor()
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        textField.tintColor = UIColor.whiteColor()
        textField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}