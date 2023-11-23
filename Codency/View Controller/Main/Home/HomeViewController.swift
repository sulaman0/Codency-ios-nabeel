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
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    private func setupCollectionView() {
        homeCollectionView.register(UINib(nibName: HomeCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.className)
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to send a alert to the Manager?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK:- Collectionview delegate and datasource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.className, for: indexPath) as? HomeCollectionViewCell else {
            return HomeCollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAlert()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: width)
    }
}
