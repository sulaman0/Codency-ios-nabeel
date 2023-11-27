//
//  AlertsViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 25/11/2023.
//

import UIKit

class AlertsViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var alertTableView: UITableView!
    
    //MARK:- Properties
    private var colors: [UIColor] = [
        .red, .blue, .orange, .systemPink
    ]
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViewView()
    }
    
    private func setupTableViewView() {
        alertTableView.delegate = self
        alertTableView.dataSource = self
        alertTableView.register(UINib(nibName: AlertsTableViewCell.className,
                                      bundle: nil),
                                forCellReuseIdentifier: AlertsTableViewCell.className)
    }
    
    //MARK:- IBActions
    @IBAction func didTapFilter(_ sender: Any) {
        if let vc: FiltersViewController = UIStoryboard.initiate(storyboard: .filters) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
        }
    }
}

//MARK:- Collectionview delegate and datasource
extension AlertsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertsTableViewCell.className, for: indexPath) as? AlertsTableViewCell else {
            return AlertsTableViewCell()
        }
        cell.contentView.backgroundColor = colors[indexPath.row]
        cell.respondButton.setTitleColor(colors[indexPath.row], for: .normal)
        return cell
    }
}
