//
//  UpdatePasswordViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 22/11/2023.
//

import UIKit

class UpdatePasswordViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var passwordEyeIcon: UIButton!
    @IBOutlet weak var confirmPasswordEyeIcon: UIButton!
    
    //MARK:- Properties
    var token: String = ""
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- UI Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapPasswordIcon(_ sender: Any) {
        passwordTF.isSecureTextEntry.toggle()
        passwordTF.isSecureTextEntry ? passwordEyeIcon.setImage(UIImage(named: "EyeIcon"), for: .normal) : passwordEyeIcon.setImage(UIImage(named: "Back"), for: .normal)
    }
    
    @IBAction func didTapConfirmPasswordIcon(_ sender: Any) {
        confirmPasswordTF.isSecureTextEntry.toggle()
        confirmPasswordTF.isSecureTextEntry ? confirmPasswordEyeIcon.setImage(UIImage(named: "EyeIcon"), for: .normal) : confirmPasswordEyeIcon.setImage(UIImage(named: "Back"), for: .normal)
    }
    
    @IBAction func didTapUpdatePassword(_ sender: Any) {
        guard let password = passwordTF.text, !password.isEmpty else {
            Commons.showError(controller: self.navigationController ?? self, message: "Please Enter Password")
            return
        }
        
        guard let confirmPassword = confirmPasswordTF.text, !confirmPassword.isEmpty else {
            Commons.showError(controller: self.navigationController ?? self, message: "Please Confirm Password")
            return
        }
        
        guard password == confirmPassword else {
            Commons.showError(controller: self.navigationController ?? self, message: "Password and Confirm Password should be same")
            return
        }
        
        Task {
            do {
                Commons.showActivityIndicator()
                let _ = try await APIHandler.shared.updatePassword(with: password,
                                                                          confirmPassword: confirmPassword,
                                                                          token: token)
                Commons.hideActivityIndicator()
                navigationController?.popToRootViewController(animated: true)
            } catch (let error) {
                Commons.hideActivityIndicator()
                Commons.showError(controller: self.navigationController ?? self, message: error.localizedDescription)
            }
        }
    }
}
