//
//  BuyGroceriesViewController.swift
//  COVID
//
//  Created by Prem Dhoot on 5/30/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class BuyGroceriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var groceryRequest: [DataSnapshot] = []
    var locationManager = CLLocationManager()
    var driverLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        tableView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        Database.database().reference().child("GroceryRequest").observe(.childAdded) { (snapshot) in
            if let groceryRequestDictionary = snapshot.value as? [String:AnyObject] {
                if let driverLat = groceryRequestDictionary["driverLat"] as? Double {
                    
                } else {
                    self.groceryRequest.append(snapshot)
                    self.tableView.reloadData()
                }
            }
           
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.tableView.reloadData()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coord = manager.location?.coordinate {
            driverLocation = coord
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as? OrderTableViewCell
        
        let snapshot = groceryRequest[indexPath.row]
        
        if let groceryRequestDictionary = snapshot.value as? [String:Any] {
            
            if let email = groceryRequestDictionary["email"] as? String {
                
                if let latitude = groceryRequestDictionary["lat"] as? Double {
                    
                    if let longitude = groceryRequestDictionary["long"] as? Double {
                        
                        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                        
                        let riderCLLocation = CLLocation(latitude: latitude, longitude: longitude)
                        
                        let distance = driverCLLocation.distance(from: riderCLLocation) / 1609.34
                        
                        let roundedDist = round(distance * 100) / 100
                        
                        cell?.orderEmailName?.text = email
                        
                        cell?.distanceLabel.text = "\(roundedDist) mi"

                    }
                    
                }
                

            }
        
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = groceryRequest[indexPath.row]
        performSegue(withIdentifier: "acceptSegue", sender: snapshot)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let acceptVC = segue.destination as? ConfirmOrderViewController {
            
            if let snapshot = sender as? DataSnapshot {
                
                if let groceryRequestDictionary = snapshot.value as? [String:Any] {
                           
                    if let email = groceryRequestDictionary["email"] as? String {
                        
                        if let latitude = groceryRequestDictionary["lat"] as? Double {
                            
                            if let longitude = groceryRequestDictionary["long"] as? Double {
                                
                                if let item1 = groceryRequestDictionary["item1"] as? String {
                                    
                                    if let item2 = groceryRequestDictionary["item2"] as? String {
                                        
                                        if let item3 = groceryRequestDictionary["item3"] as? String {
                                            
                                            if let item4 = groceryRequestDictionary["item4"] as? String {
                                                
                                                if let item5 = groceryRequestDictionary["item5"] as? String {
                                                    
                                                    acceptVC.requestEmail = email
                                                    
                                                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                                    
                                                    acceptVC.requestLocation = location
                                                    
                                                    acceptVC.itemArray.append(item1)
                                                    acceptVC.itemArray.append(item2)
                                                    acceptVC.itemArray.append(item3)
                                                    acceptVC.itemArray.append(item4)
                                                    acceptVC.itemArray.append(item5)
                                                    acceptVC.driverLocation = driverLocation
                                
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                
            }
            
        }
        
    }
    
    
    
}
