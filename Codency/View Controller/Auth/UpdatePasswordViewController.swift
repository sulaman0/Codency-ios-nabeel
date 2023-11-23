//
//  UpdatePasswordViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 22/11/2023.
//

import UIKit

class UpdatePasswordViewController: UIViewController {

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- UI Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapUpdatePassword(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
