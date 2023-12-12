//
//  AlertsViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 25/11/2023.
//

import UIKit

class AlertsViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userDesignationLbl: UILabel!
    
    @IBOutlet weak var alertTableView: UITableView!
    
    //MARK:- Properties
    private var isApiCalling  = false
    private var emergencyAlertsRes: AlarmResponse? {
        didSet {
            alertTableView.reloadData()
        }
    }
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViewView()
        getEmergencyAlerts()
        setupUserData()
    }
    
    private func setupTableViewView() {
        alertTableView.delegate = self
        alertTableView.dataSource = self
        alertTableView.register(UINib(nibName: AlertsTableViewCell.className,
                                      bundle: nil),
                                forCellReuseIdentifier: AlertsTableViewCell.className)
        
        alertTableView.setUpRefresherControll(tintColor: UIColor.appRed ?? .red ) { [weak self] in
            guard let `self` = self else { return }
            self.emergencyAlertsRes = nil
            self.alertTableView.reloadData()
            
            
            self.getEmergencyAlerts(showLoader: false)
        }
    }
    
    private func setupUserData() {
        usernameLbl.text = UserDefaultsConfig.user?.name
        userDesignationLbl.text = UserDefaultsConfig.user?.designation
    }
    
    private func getEmergencyAlerts(showLoader: Bool = true) {
        Task {
            do {
                isApiCalling = true
                if showLoader {
                    Commons.showActivityIndicator()
                }
                emergencyAlertsRes = try await APIHandler.shared.getAlarmAlerts()?.payload
                isApiCalling = false
                Commons.hideActivityIndicator()
                alertTableView.stopRefresher()
            } catch (let error) {
                Commons.hideActivityIndicator()
                alertTableView.stopRefresher()
                guard let error = error as? APIError else { return }
                switch error {
                case .serverError(let message):
                    Commons.showError(controller: self.navigationController ?? self, message: message)
                }
            }
        }
    }
    
    private func respondAlert(with action: String, of id: String) {
        Task {
            do {
                    Commons.showActivityIndicator()
                try await APIHandler.shared.respondAlert(with: action, of: id)
                Commons.hideActivityIndicator()
                if let index = emergencyAlertsRes?.data?.firstIndex(where: { $0.id == Int(id)}) {
                    emergencyAlertsRes?.data?[index].should_show_action_btn = false
                }
                alertTableView.reloadData()
            } catch (let error) {
                Commons.hideActivityIndicator()
                alertTableView.stopRefresher()
                guard let error = error as? APIError else { return }
                switch error {
                case .serverError(let message):
                    Commons.showError(controller: self.navigationController ?? self, message: message)
                }
            }
        }
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
        emergencyAlertsRes?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertsTableViewCell.className, for: indexPath) as? AlertsTableViewCell else {
            return AlertsTableViewCell()
        }
        cell.delegate = self
        cell.item = emergencyAlertsRes?.data?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if emergencyAlertsRes?.data?.isLastCell(index: indexPath.row) ?? false &&
            emergencyAlertsRes?.meta?.shouldCallAPI ?? false &&
            !isApiCalling {
            getEmergencyAlerts()
        }
    }
}

extension AlertsViewController: AlertsTableViewCellProtocol {
    func didTapIgnorebutton(item: Alarm) {
        Commons.showOptionsAlertAction(message: "Are you sure you want to Ignore \(item.name ?? "") Alert?",
                                       negativeActionTitle: "No",
                                       positiveActionTitle: "Yes") {
            // Do Nothing
        } positiveCompletionHandler: {
            // Respond
            self.respondAlert(with: "reject", of: item.id?.toString() ?? "")
        }
    }
    
    func didTapRespondbutton(item: Alarm) {
        Commons.showOptionsAlertAction(message: "Are you sure you want to respond to \(item.name ?? "") Alert?",
                                       negativeActionTitle: "No",
                                       positiveActionTitle: "Yes") {
            // Do Nothing
        } positiveCompletionHandler: {
            // Respond
            self.respondAlert(with: "accept", of: item.id?.toString() ?? "")
        }
    }
}
