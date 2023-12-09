//
//  HomeViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 23/11/2023.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK:- Outlets
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
                Commons.showError(controller: self.navigationController ?? self, message: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(item: EmergencyCode) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to send a alert to the Manager?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {  [weak self] _ in
            guard let `self` = self else { return }
        }))
        present(alert, animated: true, completion: nil)
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
