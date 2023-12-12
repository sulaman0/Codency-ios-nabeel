//
//  FiltersViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 25/11/2023.
//

import UIKit

class FiltersViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var emergencyCodesCV: UICollectionView!
    @IBOutlet weak var staffCV: UICollectionView!
    
    //MARK:- Properties
    private var emergencyCodeDataSource: EmergencyCodeDataSource?
    private var staffDataSource: StaffDataSource?

    private var emergencyCodes = [ECGCode]() {
        didSet {
            emergencyCodeDataSource?.configueCode(codes: emergencyCodes)
            emergencyCodesCV.reloadData()
        }
    }
    private var staff = [Staff]()
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEmergencyCodeCollectionView()
        setupStaffCollectionView()
    }
    
    private func setupEmergencyCodeCollectionView() {
        emergencyCodeDataSource = EmergencyCodeDataSource(codes: nil, context: self)
        emergencyCodesCV.delegate = emergencyCodeDataSource
        emergencyCodesCV.dataSource = emergencyCodeDataSource
        emergencyCodesCV.register(UINib(nibName: SelectFilterCollectionViewCell.className,
                                        bundle: nil),
                                  forCellWithReuseIdentifier: SelectFilterCollectionViewCell.className)
        emergencyCodesCV.register(UINib(nibName: FilterCollectionViewCell.className,
                                        bundle: nil),
                                  forCellWithReuseIdentifier: FilterCollectionViewCell.className)
    }
    private func setupStaffCollectionView() {
        staffDataSource = StaffDataSource(staff: nil, context: self)
        staffCV.delegate = staffDataSource
        staffCV.dataSource = staffDataSource
        staffCV.register(UINib(nibName: SelectFilterCollectionViewCell.className,
                                        bundle: nil),
                                  forCellWithReuseIdentifier: SelectFilterCollectionViewCell.className)
        staffCV.register(UINib(nibName: FilterCollectionViewCell.className,
                                        bundle: nil),
                                  forCellWithReuseIdentifier: FilterCollectionViewCell.className)
    }
    
    //MARK:- IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension FiltersViewController: EmergencyCodesViewControllerDelegate {
    func didSelectCodes(codes: [ECGCode]) {
        emergencyCodes = codes
    }
}

final class EmergencyCodeDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var emergencyCodes: [ECGCode]?
    private let context: UIViewController
    
    init(codes: [ECGCode]?, context: UIViewController) {
        self.emergencyCodes = codes
        self.context = context
    }
    
    func configueCode(codes: [ECGCode]) {
        self.emergencyCodes = codes
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if emergencyCodes == nil {
            return 1
        } else {
            return emergencyCodes?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if emergencyCodes == nil && indexPath.item == 0 {
            return configureSelectCell(collectionView: collectionView, indexPath: indexPath)
        } else {
            return configureFilterCell(collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc: EmergencyCodesViewController = UIStoryboard.initiate(storyboard: .filters) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = context as? FiltersViewController
            context.present(vc, animated: true)
        }
    }
    
    private func configureSelectCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectFilterCollectionViewCell.className, for: indexPath) as? SelectFilterCollectionViewCell else {
            return SelectFilterCollectionViewCell()
        }
        return cell
    }
    
    private func configureFilterCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.className, for: indexPath) as? FilterCollectionViewCell else {
            return FilterCollectionViewCell()
        }
        return cell
    }
}

final class StaffDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var staff: [Staff]?
    private let context: UIViewController

    init(staff: [Staff]?, context: UIViewController) {
        self.staff = staff
        self.context = context
    }
    
    func configueStaff(staff: [Staff]) {
        self.staff = staff
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if staff == nil {
            return 1
        } else {
            return staff?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if staff == nil && indexPath.item == 0 {
            return configureSelectCell(collectionView: collectionView, indexPath: indexPath)
        } else {
            return configureFilterCell(collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    private func configureSelectCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectFilterCollectionViewCell.className, for: indexPath) as? SelectFilterCollectionViewCell else {
            return SelectFilterCollectionViewCell()
        }
        return cell
    }
    
    private func configureFilterCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.className, for: indexPath) as? FilterCollectionViewCell else {
            return FilterCollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc: StaffViewController = UIStoryboard.initiate(storyboard: .filters) {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            context.present(vc, animated: true)
        }
    }
}
