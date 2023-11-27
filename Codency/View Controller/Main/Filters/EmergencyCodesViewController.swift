//
//  EmergencyCodesViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 25/11/2023.
//

import UIKit

class EmergencyCodesViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var emergencyCodeTV: UITableView!

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    private func configureTableView() {
        emergencyCodeTV.delegate = self
        emergencyCodeTV.dataSource = self
        emergencyCodeTV.register(UINib(nibName: CodesAndStaffTableViewCell.className,
                                       bundle: nil),
                                 forCellReuseIdentifier: CodesAndStaffTableViewCell.className)
    }
    
    //MARK:- IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension EmergencyCodesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodesAndStaffTableViewCell.className, for: indexPath) as? CodesAndStaffTableViewCell else {
            return CodesAndStaffTableViewCell()
        }
        return cell
    }
}
