//
//  AlertsTableViewCell.swift
//  Codency
//
//  Created by Nabeel Nazir on 25/11/2023.
//

import UIKit

class AlertsTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var respondButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0,
                                                                     left: 0,
                                                                     bottom: 10,
                                                                     right: 0))
    }
}
