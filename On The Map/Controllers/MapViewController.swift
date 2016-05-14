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
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if tmpData.students.isEmpty {
            getStudents()
        }
        
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
        
        var annotations = [MKPointAnnotation]()

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

//protocol implementation:
extension MapViewController: CommonOperations
{
    func refresh(sender: AnyObject)
    {
        setLocations(tmpData.students)
    }
}
