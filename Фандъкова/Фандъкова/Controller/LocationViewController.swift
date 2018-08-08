//
//  ViewController.swift
//  userLocation
//
//  Created by Sebastian Hette on 19.09.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol LocationDelegate {
    func getLocation() -> CLLocation
    var locationChanged: Bool? {get set}
}

class LocationViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate, LocationDelegate {
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        cell?.delegate = self
    }
    
    //MARK: Map
    @IBOutlet weak var mapView: MKMapView!
    var cell: LocationCell?
    let manager = CLLocationManager()
    var userLocation = CLLocation()
    var anotationSet = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        mapView.mapType = MKMapType.standard
        if !anotationSet{
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: locValue, span: span)
            mapView.setRegion(region, animated: true)
            anotationSet = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Remove all annotations
        self.mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.centerCoordinate
        annotation.title = "Rico"
        annotation.subtitle = "illegal"
        self.mapView.addAnnotation(annotation)
        //SETTING THE USER LOCATION EVERY TIME THE REGION UPDATES
        userLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
    }
    
    //MARK: Location Protocol
    var locationDidChange: Bool = false
    var locationChanged: Bool?{
        get{
            return locationDidChange
        } set{
            locationDidChange = (newValue != nil)
        }
    }
    
    func getLocation() -> CLLocation {
        return userLocation
    }
    
    @IBAction func sendLocation(_ sender: UIBarButtonItem) {
        locationChanged = true
        _ = navigationController?.popViewController(animated: true)
    }
}

