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

class LocationViewController: UIViewController, CLLocationManagerDelegate, LocationDelegate {
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        cell?.delegate = self
    }
    
    //MARK: Map
    @IBOutlet weak var map: MKMapView!
    var cell: LocationCell?
    let manager = CLLocationManager()
    var userLocation = CLLocation()

    
    //keeps track of current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        userLocation = location
        
        self.map.showsUserLocation = true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

