//
//  ConfirmOrderViewController.swift
//  COVID
//
//  Created by Prem Dhoot on 5/30/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class ConfirmOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var requestLocation = CLLocationCoordinate2D()
    var requestEmail = ""
    var itemArray = [String]()
    
    var driverLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = requestLocation
        annotation.title = "Delivery Location"
        mapView.addAnnotation(annotation)
        
    }
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        //Update the Ride Request
        Database.database().reference().child("GroceryRequest").queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["driverLat": self.driverLocation.latitude, "driverLong": self.driverLocation.longitude])
            Database.database().reference().child("GroceryRequest").removeAllObservers()
        }
        
        //Give Directions
        let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let placemark = MKPlacemark(placemark: placemarks[0])
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = "Delivery for \(self.requestEmail)"
                    let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: options)
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryItem", for: indexPath) as? ConfirmedItemTableViewCell
        
        cell?.finalItemName.text = "\(indexPath.row + 1). \(itemArray[indexPath.row])"
        
        return cell!
        
    }
    
    
    
    
    
    
}
