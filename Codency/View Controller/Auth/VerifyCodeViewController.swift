//
//  VerifyCodeViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 22/11/2023.
//

import UIKit

class VerifyCodeViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var resendCodeBtn: UIButton!
    
    //MARK:- Properties
    var email: String = ""
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func goToUpdatePassword(with token: String) {
        if let vc: UpdatePasswordViewController = UIStoryboard.initiate(storyboard: .auth) {
            vc.token = token
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- UI Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapResendCode(_ sender: Any) {
        Task {
            do {
                Commons.showActivityIndicator()
                try await APIHandler.shared.resetPassword(with: email)
                Commons.hideActivityIndicator()
                self.email = email
            } catch (let error) {
                Commons.hideActivityIndicator()
                Commons.showError(controller: self.navigationController ?? self, message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func didTapVerifyCode(_ sender: Any) {
        guard let code = codeTF.text, code.count == 6 else {
            Commons.showError(controller: self.navigationController ?? self, message: "Please Enter Valid Code")
            return
        }
        
        Task {
            do {
                Commons.showActivityIndicator()
                let response = try await APIHandler.shared.verifyCode(with: email, code: code)
                Commons.hideActivityIndicator()
                if let token = response?.payload?.token {
                    goToUpdatePassword(with: token)
                }
            } catch (let error) {
                Commons.hideActivityIndicator()
                Commons.showError(controller: self.navigationController ?? self, message: error.localizedDescription)
            }
        }
    }
}
