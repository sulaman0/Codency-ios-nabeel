//
//  TabbarViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 22/11/2023.
//

import UIKit

class TabbarViewController: UITabBarController {

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
}

// MARK: - UITabBarControllerDelegate
extension TabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: LogoutViewController.self) {
            Commons.showOptionsAlertAction(message: "Are you sure you want to Logout?",
                                           negativeActionTitle: "No",
                                           positiveActionTitle: "Yes") {
                print("No Pressed")
            } positiveCompletionHandler: {
                UserDefaultsConfig.user = nil
                UserDefaultsConfig.token = nil
                Commons.goToLogin()
            }

            return false
        }
        
        return true
    }
}
