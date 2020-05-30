//
//  StatusViewController.swift
//  COVID
//
//  Created by Prem Dhoot on 5/30/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth

class StatusViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var paypalEmail: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    var driverLocation = CLLocationCoordinate2D()
    var userLocation = CLLocationCoordinate2D()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("GroceryRequest").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                    if let driverLat = rideRequestDictionary["driverLat"] as? Double {
                        if let driverLong = rideRequestDictionary["driverLong"] as? Double {
                            if let userLat = rideRequestDictionary["lat"] as? Double {
                                if let userLong = rideRequestDictionary["long"] as? Double {
                                    self.driverLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLong)
                                    self.userLocation = CLLocationCoordinate2D(latitude: userLat, longitude: userLong)
                                    self.displayRiderAndDriver()
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func displayRiderAndDriver() {
        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
        let riderCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let distance = driverCLLocation.distance(from: riderCLLocation) / 1609.34
        let roundedDist = round(distance * 100) / 100
        etaLabel.text = "Your volunteer is \(roundedDist)mi away!"
        mapView.removeAnnotations(mapView.annotations)
        let latDelta = abs(driverLocation.latitude - userLocation.latitude) * 2 + 0.005
        let longDelta = abs(driverLocation.longitude - userLocation.longitude) * 2 + 0.005
        let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta))
        mapView.setRegion(region, animated: true)
        let volunteerAnnotation = MKPointAnnotation()
        volunteerAnnotation.coordinate = driverLocation
        volunteerAnnotation.title = "Your Volunteer's Location"
        mapView.addAnnotation(volunteerAnnotation)
        let citizenAnnotation = MKPointAnnotation()
        citizenAnnotation.coordinate = userLocation
        citizenAnnotation.title = "Your Location"
        mapView.addAnnotation(citizenAnnotation)
    }
    
}
