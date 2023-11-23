//
//  LoginViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 21/11/2023.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK:- UI Actions
    @IBAction func didTapForgotPassword(_ sender: Any) {
        if let vc: ForgotPasswordViewController = UIStoryboard.initiate(storyboard: .auth) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        if let vc: TabbarViewController = UIStoryboard.initiate(storyboard: .main) {
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
}
