//
//  ForgotPasswordViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 22/11/2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- UI Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapResetPassword(_ sender: Any) {
        if let vc: VerifyCodeViewController = UIStoryboard.initiate(storyboard: .auth) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
