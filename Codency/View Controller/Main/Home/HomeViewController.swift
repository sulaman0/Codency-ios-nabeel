//
//  HomeViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 23/11/2023.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    //MARK:- Properties
    private var isApiCalling  = false
    private var emergencyCodesRes: EmergencyCodeResponse? {
        didSet {
            homeCollectionView.reloadData()
        }
    }
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        getEmergencyCodes()
        setupUserData()
    }
    
    private func setupUserData() {
        nameLbl.text = UserDefaultsConfig.user?.name
        designationLbl.text = UserDefaultsConfig.user?.designation
    }
    
    private func setupCollectionView() {
        homeCollectionView.register(UINib(nibName: HomeCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.className)
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
    }
    
    private func getEmergencyCodes() {
        Task {
            do {
                isApiCalling = true
                Commons.showActivityIndicator()
                emergencyCodesRes = try await APIHandler.shared.getEmergencyCodes()?.payload
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
    
    private func sendEmergencyAlert(to code: Int) {
        Task {
            do {
                Commons.showActivityIndicator()
                try await APIHandler.shared.sendAlert(to: code)
                print("Alert Created")
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
    
    private func showAlert(item: EmergencyCode) {
        Commons.showOptionsAlertAction(message: "Are you sure you want to send a alert to the Manager?",
                                       negativeActionTitle: "No, Cancel",
                                       positiveActionTitle: "Yes") {
            //
        } positiveCompletionHandler: { [weak self] in
            guard let `self` = self else { return }
            self.sendEmergencyAlert(to: Int(item.code ?? "") ?? 0)
        }
    }
}

//MARK:- Collectionview delegate and datasource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emergencyCodesRes?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.className, for: indexPath) as? HomeCollectionViewCell else {
            return HomeCollectionViewCell()
        }
        cell.item = emergencyCodesRes?.data?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = emergencyCodesRes?.data?[indexPath.item] {
            showAlert(item: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if emergencyCodesRes?.data?.isLastCell(index: indexPath.row) ?? false &&
            emergencyCodesRes?.meta?.shouldCallAPI ?? false &&
            !isApiCalling {
            getEmergencyCodes()
        }
    }
}
