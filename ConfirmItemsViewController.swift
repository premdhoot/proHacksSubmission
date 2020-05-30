//
//  ConfirmItemsViewController.swift
//  COVID
//
//  Created by Prem Dhoot on 5/30/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class ConfirmItemsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var deliveryCalled = false
    
    var finalItems = [String]()
    
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("GroceryRequest").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                
                self.deliveryCalled = true
                self.confirmButton.setTitle("Cancel Order", for: .normal)
                
                Database.database().reference().child("GroceryRequest").removeAllObservers()
                
            })
        }
        
    }
    
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.isUserInteractionEnabled = false
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {
            (response, error) in
            
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if response == nil {
                
                print("error")
                
            } else {
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                let latitude = response!.boundingRegion.center.latitude
                let longitude = response!.boundingRegion.center.longitude
                
                let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.userLocation = center
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.title = "Delivery Location"
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                self.mapView.addAnnotation(annotation)
            
            }
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Delivery Location"
            mapView.addAnnotation(annotation)
        }
        
    }
    
    var groceryRequestDictionary = [String: Any]()
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        if let email = Auth.auth().currentUser?.email {
            
            if deliveryCalled {
                
                deliveryCalled = false
                
                confirmButton.setTitle("Confirm Order", for: .normal)
                Database.database().reference().child("GroceryRequest").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                    snapshot.ref.removeValue()
                    Database.database().reference().child("GroceryRequest").removeAllObservers()
                })
                
            } else {
                
                if finalItems.count == 1 {
                    groceryRequestDictionary = ["email": email, "item1": finalItems[0], "item2": "", "item3": "", "item4": "", "item5": "", "lat": userLocation.latitude, "long": userLocation.longitude]
                } else if finalItems.count == 2 {
                    groceryRequestDictionary = ["email": email, "item1": finalItems[0], "item2": finalItems[1], "item3": "", "item4": "", "item5": "", "lat": userLocation.latitude, "long": userLocation.longitude]
                } else if finalItems.count == 3 {
                    groceryRequestDictionary = ["email": email, "item1": finalItems[0], "item2": finalItems[1], "item3": finalItems[2], "item4": "", "item5": "", "lat": userLocation.latitude, "long": userLocation.longitude]
                } else if finalItems.count == 4 {
                     groceryRequestDictionary = ["email": email, "item1": finalItems[0], "item2": finalItems[1], "item3": finalItems[2], "item4": finalItems[3], "item5": "", "lat": userLocation.latitude, "long": userLocation.longitude]
                } else if finalItems.count == 5 {
                     groceryRequestDictionary = ["email": email, "item1": finalItems[0], "item2": finalItems[1], "item3": finalItems[2], "item4": finalItems[3], "item5": finalItems[5], "lat": userLocation.latitude, "long": userLocation.longitude]
                }
                
                Database.database().reference().child("GroceryRequest").childByAutoId().setValue(groceryRequestDictionary)
                
                deliveryCalled = true
                confirmButton.setTitle("Cancel Order", for: .normal)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "confirmItem", for: indexPath) as? ItemTableViewCell
        cell?.itemName.text = "\(indexPath.row + 1). \(finalItems[indexPath.row])"
        
        return cell!
        
    }
    

    
    
}
