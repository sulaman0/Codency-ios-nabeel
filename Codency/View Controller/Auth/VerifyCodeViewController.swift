//
//  VerifyCodeViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 22/11/2023.
//

import UIKit

class VerifyCodeViewController: UIViewController {

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- UI Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapResendCode(_ sender: Any) {
    }
    
    @IBAction func didTapVerifyCode(_ sender: Any) {
        if let vc: UpdatePasswordViewController = UIStoryboard.initiate(storyboard: .auth) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
