//
//  ViewController.swift
//  Pizza Hunter
//
//  Created by Michael Filippini on 7/11/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoBar: UIView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationPhoneNum: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    let locationManager = CLLocationManager()
    var region = MKCoordinateRegion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoBar.transform = CGAffineTransform(translationX: 0, y: 275)
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        infoBar.layer.cornerRadius = 20

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
    }
    
    

    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.infoBar.transform = CGAffineTransform(translationX: 0, y: 275)
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.025, 0.025)
        region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "pizza"
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                for mapItem in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    annotation.title = mapItem.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        UIView.animate(withDuration: 0.3) {
            self.infoBar.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

