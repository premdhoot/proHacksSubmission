//
//  HomeViewController.swift
//  COVID
//
//  Created by Prem Dhoot on 5/30/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import UIKit
import paper_onboarding

class CitizenHomeViewController: UIViewController, PaperOnboardingDelegate, PaperOnboardingDataSource {
    
    @IBOutlet weak var onboardingView: OnboardingView!
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        if onboardingView.currentIndex == 0 {
            performSegue(withIdentifier: "itemSegue", sender: self)
        } else if onboardingView.currentIndex == 1 {
            performSegue(withIdentifier: "statusSegue", sender: self)
        } else if onboardingView.currentIndex == 2 {
            performSegue(withIdentifier: "logOutSegue", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingView.delegate = self
        onboardingView.dataSource = self

    }
    
    func onboardingItemsCount() -> Int {
        3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)

        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
               
        return [
                   
            OnboardingItemInfo(informationImage: UIImage(named: "groceries")!, title: "Request Supplies", description: "Delivered to your current location", pageIcon: UIImage(), color: backgroundColorOne, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
                   
            OnboardingItemInfo(informationImage: UIImage(named: "store")!, title: "Order Status", description: "View the current status of your latest order", pageIcon: UIImage(), color: backgroundColorTwo, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
                   
            OnboardingItemInfo(informationImage: UIImage(named: "editUser")!, title: "Edit Profile", description: "Edit Privacy Settings and User Info", pageIcon: UIImage(), color: backgroundColorThree, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
                   
            ][index]
           
    }
    


}
