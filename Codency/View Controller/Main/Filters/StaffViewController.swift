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
    
    //MARK:- Properties
    private var isApiCalling  = false
    private var userResponse: FilterECodeResponse? {
        didSet {
            staffCodeTV.reloadData()
        }
    }
    private var filteredList = [ECGCode]() {
        didSet {
            staffCodeTV.reloadData()
        }
    }
    weak var delegate: EmergencyCodesViewControllerDelegate?

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        getStaff()
    }
    
    private func configureTableView() {
        staffCodeTV.delegate = self
        staffCodeTV.dataSource = self
        staffCodeTV.register(UINib(nibName: CodesAndStaffTableViewCell.className,
                                       bundle: nil),
                                 forCellReuseIdentifier: CodesAndStaffTableViewCell.className)
    }
    
    private func getStaff() {
        Task {
            do {
                isApiCalling = true
                Commons.showActivityIndicator()
                userResponse = try await APIHandler.shared.getStaffForFilters()?.payload
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
            self.delegate?.didSelectStaff(staff: self.filteredList)
        }
    }
}

extension StaffViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userResponse?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodesAndStaffTableViewCell.className, for: indexPath) as? CodesAndStaffTableViewCell else {
            return CodesAndStaffTableViewCell()
        }
        let item = userResponse?.data?[indexPath.row]
        cell.configureCell(item: item,
                           isSelected: filteredList.contains(where: { $0.id == item?.id }))
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if userResponse?.data?.isLastCell(index: indexPath.row) ?? false &&
            userResponse?.meta?.shouldCallAPI ?? false &&
            !isApiCalling {
            getStaff()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = filteredList.firstIndex(where: { $0.id == userResponse?.data?[indexPath.row].id }) {
            filteredList.remove(at: index)
        } else {
            if let item = userResponse?.data?[indexPath.row] {
                filteredList.append(item)
            }
        }
    }
}
