//
//  HomeCollectionViewCell.swift
//  Codency
//
//  Created by Nabeel Nazir on 23/11/2023.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var serialNoLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var item: EmergencyCode? {
        didSet {
            mainView.backgroundColor = item?.clr_code?.hexStringToUIColor()
            
            serialNoLbl.text = "\(item?.serial_no ?? 0)"
            nameLbl.text = item?.name
            codeLbl.text = "Code: \(item?.code ?? "")"
        }
    }
}
