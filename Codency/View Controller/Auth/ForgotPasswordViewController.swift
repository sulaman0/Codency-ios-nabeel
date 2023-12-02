//
//  ForgotPasswordViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 22/11/2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var emailTF: UITextField!
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func goToVerifyCode() {
        if let vc: VerifyCodeViewController = UIStoryboard.initiate(storyboard: .auth) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- UI Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapResetPassword(_ sender: Any) {
        guard let email = emailTF.text, email.isEmail else {
            // Show Error
            return
        }
        
        Task {
            do {
                try await APIHandler.shared.resetPassword(with: email)
                goToVerifyCode()
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
    }
}
