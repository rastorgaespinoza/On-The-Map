//
//  MapViewController.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 03-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit
import MapKit



class MapViewController: UIViewController {

    private var tmpData: TemporalData = TemporalData.sharedInstance()
    private var pConnection: ParseConnection = ParseConnection.sharedInstance()
    private var annotations = [MKPointAnnotation]()
    private var customPopoverMaskView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if tmpData.students.isEmpty {
            getStudents()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.startRefresh), name: startRefreshNotif, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.stopRefresh), name: stopRefreshNotif, object: nil)
    }
    
    
    private func getStudents() {
        pConnection.getStudentLocations { (result, errorString) in
            if let result = result {
                self.tmpData.students = result
                dispatch_async(dispatch_get_main_queue()) {
                    self.setLocations(self.tmpData.students)
                }
                
            }else {
                Helper.presentAlert(self, title: "Error:", message: errorString!)
            }
        }
    }
    
    func setLocations(locations: [StudentLocation]) {

        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        for student in locations {
            
            let lat = CLLocationDegrees(student.latitude )
            let long = CLLocationDegrees(student.longitude)

            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        mapView.addAnnotations(annotations)
    }
    
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            if let urlToOpen = view.annotation?.subtitle! {
                Helper.openURL(self, urlString: urlToOpen)
            }
        }
    }
}


extension MapViewController {
    
    func startRefresh() {
        //add activityIndicator...
        customPopoverMaskView = UIView(frame: CGRectMake(0,0, view.bounds.size.width, view.bounds.size.height ) )
        customPopoverMaskView.backgroundColor = UIColor.blackColor()
        customPopoverMaskView.alpha = 0.3
        customPopoverMaskView.userInteractionEnabled = false
        
        UIView.transitionWithView(view, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.view.addSubview(self.customPopoverMaskView)
            }, completion: { _ in
        self.activityIndicator.startAnimating()
        })
        
    }
    
    func stopRefresh() {
        //end activityIndicator...
        UIView.transitionWithView(view, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.customPopoverMaskView.removeFromSuperview()
            }, completion: { _ in
            self.activityIndicator.stopAnimating()
        })
        
        setLocations(tmpData.students)
    }
    
}

