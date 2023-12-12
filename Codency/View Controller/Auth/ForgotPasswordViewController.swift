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

        configureTextFields()
    }
    
    private func configureTextFields() {
        emailTF.delegate = self
        emailTF.returnKeyType = .done
    }
    
    private func goToVerifyCode(with email: String) {
        if let vc: VerifyCodeViewController = UIStoryboard.initiate(storyboard: .auth) {
            vc.email = email
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- UI Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapResetPassword(_ sender: Any) {
        guard let email = emailTF.text, email.isEmail else {
            Commons.showError(controller: self.navigationController ?? self, message: "Please Enter Valid Email")
            return
        }
        
        Task {
            do {
                Commons.showActivityIndicator()
                try await APIHandler.shared.resetPassword(with: email)
                Commons.hideActivityIndicator()
                goToVerifyCode(with: email)
            } catch (let error) {
                Commons.hideActivityIndicator()
                guard let error = error as? APIError else { return }
                switch error {
                case .serverError(let message):
                    Commons.showError(controller: self.navigationController ?? self, message: message)
                }
            }
        }
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
