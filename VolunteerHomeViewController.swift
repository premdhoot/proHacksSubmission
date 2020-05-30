//
//  VolunteerHomeViewController.swift
//  COVID
//
//  Created by Prem Dhoot on 5/30/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import UIKit
import paper_onboarding

class VolunteerHomeViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    @IBOutlet weak var onboardingView: OnboardingView!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        onboardingView.delegate = self
        onboardingView.dataSource = self

    }
    @IBAction func goThereButtonPressed(_ sender: Any) {
        if onboardingView.currentIndex == 0 {
            performSegue(withIdentifier: "buyGroceries", sender: self)
        } else if onboardingView.currentIndex == 2 {
            performSegue(withIdentifier: "logOutSegue", sender: self)
        }
    }
    

    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)

        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
               
        return [
                   
            OnboardingItemInfo(informationImage: UIImage(named: "groceries")!, title: "Buy Groceries", description: "List of citizens in need of supplies", pageIcon: UIImage(), color: backgroundColorOne, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
                   
            OnboardingItemInfo(informationImage: UIImage(named: "store")!, title: "Find Stores", description: "Find convenience stores near your location", pageIcon: UIImage(), color: backgroundColorTwo, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
                   
            OnboardingItemInfo(informationImage: UIImage(named: "editUser")!, title: "Edit Profile", description: "Edit Privacy Settings and User Info", pageIcon: UIImage(), color: backgroundColorThree, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
                   
            ][index]
    }
}
