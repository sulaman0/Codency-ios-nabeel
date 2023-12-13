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
    
    @IBOutlet weak var passwordEyeButton: UIButton!
    
    //MARK:- Properties
    private var user: UserData? {
        didSet {
            UserDefaultsConfig.user = user?.user
            UserDefaultsConfig.token = user?.token
            goToHome()
        }
    }
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
    }
    
    private func configureTextFields() {
        emailTF.delegate = self
        emailTF.returnKeyType = .next
        
        passwordTF.delegate = self
        passwordTF.returnKeyType = .done
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
    
    @IBAction func didTapEyeIcon(_ sender: Any) {
        passwordTF.isSecureTextEntry.toggle()
        passwordTF.isSecureTextEntry ? passwordEyeButton.setImage(UIImage(named: "EyeIcon"), for: .normal) : passwordEyeButton.setImage(UIImage(named: "EyeClose"), for: .normal)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard let email = emailTF.text, email.isEmail else {
            Commons.showError(controller: self.navigationController ?? self, message: "Please Enter Valid Email")
            return
        }
        
        guard let password = passwordTF.text, !password.isEmpty else {
            Commons.showError(controller: self.navigationController ?? self, message: "Please Enter Password")
            return
        }
        
        Task {
            do {
                Commons.showActivityIndicator()
                let response = try await APIHandler.shared.login(with: email, password: password)
                Commons.hideActivityIndicator()
                user = response?.payload
            } catch (let error) {
                Commons.hideActivityIndicator()
                guard let error = error as? APIError else { return }
                switch error {
                case .serverError(let message):
                    Commons.showError(controller: self.navigationController ?? self,
                                      message: message)
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
