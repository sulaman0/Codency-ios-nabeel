//
//  CodesAndStaffTableViewCell.swift
//  Codency
//
//  Created by Nabeel Nazir on 25/11/2023.
//

import UIKit

class CodesAndStaffTableViewCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    func configureCell(item: ECGCode?, isSelected: Bool) {
        nameLbl.text = item?.name
        checkmarkImageView.image = getCircleImage(when: isSelected)
    }
    
    private func getCircleImage(when isSelected: Bool) -> UIImage? {
        if isSelected {
            return UIImage(systemName: "checkmark.circle.fill")
        } else {
            return UIImage(systemName: "circle")
        }
    }
}
