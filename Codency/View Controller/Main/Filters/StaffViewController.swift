//
//  StaffViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 25/11/2023.
//

import UIKit

class StaffViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var staffCodeTV: UITableView!

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    private func configureTableView() {
        staffCodeTV.delegate = self
        staffCodeTV.dataSource = self
        staffCodeTV.register(UINib(nibName: CodesAndStaffTableViewCell.className,
                                       bundle: nil),
                                 forCellReuseIdentifier: CodesAndStaffTableViewCell.className)
    }
    
    //MARK:- IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension StaffViewController: UITableViewDelegate, UITableViewDataSource {
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
