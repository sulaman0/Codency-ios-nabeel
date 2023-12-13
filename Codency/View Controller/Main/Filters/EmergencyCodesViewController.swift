//
//  EmergencyCodesViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 25/11/2023.
//

import UIKit

protocol EmergencyCodesViewControllerDelegate: AnyObject {
    func didSelectCodes(codes: [ECGCode])
    func didSelectStaff(staff: [ECGCode])
}

class EmergencyCodesViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var emergencyCodeTV: UITableView!
    
    //MARK:- Properties
    private var isApiCalling  = false
    private var emergencyCodesRes: FilterECodeResponse? {
        didSet {
            emergencyCodeTV.reloadData()
        }
    }
    private var filteredList = [ECGCode]() {
        didSet {
            emergencyCodeTV.reloadData()
        }
    }
    weak var delegate: EmergencyCodesViewControllerDelegate?

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        getEmergencyCodeList()
    }
    
    private func configureTableView() {
        emergencyCodeTV.delegate = self
        emergencyCodeTV.dataSource = self
        emergencyCodeTV.register(UINib(nibName: CodesAndStaffTableViewCell.className,
                                       bundle: nil),
                                 forCellReuseIdentifier: CodesAndStaffTableViewCell.className)
    }
    
    private func getEmergencyCodeList() {
        Task {
            do {
                isApiCalling = true
                Commons.showActivityIndicator()
                emergencyCodesRes = try await APIHandler.shared.getFilterEmergencyCodes()?.payload
                isApiCalling = false
                Commons.hideActivityIndicator()
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
    
    //MARK:- IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapApplyButton(_ sender: Any) {
        dismiss(animated: false) {
            self.delegate?.didSelectCodes(codes: self.filteredList)
        }
    }
}

extension EmergencyCodesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emergencyCodesRes?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodesAndStaffTableViewCell.className, for: indexPath) as? CodesAndStaffTableViewCell else {
            return CodesAndStaffTableViewCell()
        }
        let item = emergencyCodesRes?.data?[indexPath.row]
        cell.configureCell(item: item,
                           isSelected: filteredList.contains(where: { $0.id == item?.id }))
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if emergencyCodesRes?.data?.isLastCell(index: indexPath.row) ?? false &&
            emergencyCodesRes?.meta?.shouldCallAPI ?? false &&
            !isApiCalling {
            getEmergencyCodeList()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = filteredList.firstIndex(where: { $0.id == emergencyCodesRes?.data?[indexPath.row].id }) {
            filteredList.remove(at: index)
        } else {
            if let item = emergencyCodesRes?.data?[indexPath.row] {
                filteredList.append(item)
            }
        }
    }
}
