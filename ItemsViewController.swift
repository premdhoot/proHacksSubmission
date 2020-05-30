//
//  ItemsViewController.swift
//  COVID
//
//  Created by Prem Dhoot on 5/30/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groceryArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
           super.viewDidLoad()
                   
           tableView.delegate = self
           tableView.dataSource = self

       }

    @IBAction func confirmButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "confirmSegue", sender: self)
    }
    
    @IBAction func addItem(_ sender: Any) {
        
        if groceryArray.count == 5 {
            
            let alertController = UIAlertController(title: "Limit Reached", message: "You can only enter upto 5 times for convenience of the volunteer", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            
        } else {
            
            let alertController = UIAlertController(title: "Enter Item Name", message: nil, preferredStyle: .alert)
            alertController.addTextField { (textfield) in
                textfield.placeholder = "Ex: Bread, Napkins, Eggs..."
            }
            
            let okAction = UIAlertAction(title: "Add", style: .default) { (_) in
                if let itemTextField = alertController.textFields?[0] {
                    self.groceryArray.append(contentsOf: itemTextField.text!.components(separatedBy: ","))
                    self.tableView.reloadData()
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmSegue" {
            let cvc = segue.destination as? ConfirmItemsViewController
            cvc?.finalItems = self.groceryArray
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell
        cell?.itemName.text = "\(indexPath.row + 1). \(groceryArray[indexPath.row])"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.groceryArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    

}
