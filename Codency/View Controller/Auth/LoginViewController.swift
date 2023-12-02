//
//  LoginViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 21/11/2023.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    //MARK:- Properties
    private var user: User? {
        didSet {
            goToHome()
        }
    }
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func goToHome() {
        if let vc: TabbarViewController = UIStoryboard.initiate(storyboard: .main) {
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }

    //MARK:- UI Actions
    @IBAction func didTapForgotPassword(_ sender: Any) {
        if let vc: ForgotPasswordViewController = UIStoryboard.initiate(storyboard: .auth) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard let email = emailTF.text, email.isEmail else {
            // Show Error
            return
        }
        
        guard let password = passwordTF.text, !password.isEmpty else {
            // Show Error
            return
        }
        
        Task {
            do {
                let response = try await APIHandler.shared.login(with: email, password: password)
                user = response?.payload
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
    }
}
