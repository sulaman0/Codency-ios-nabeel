//
//  AlertsTableViewCell.swift
//  Codency
//
//  Created by Nabeel Nazir on 25/11/2023.
//

import UIKit

protocol AlertsTableViewCellProtocol: AnyObject {
    func didTapIgnorebutton(item: Alarm)
    func didTapRespondbutton(item: Alarm)
}

class AlertsTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var serialNoLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var alarmAtLbl: UILabel!
    @IBOutlet weak var alarmByLbl: UILabel!
    @IBOutlet weak var respondTimeLbl: UILabel!
    @IBOutlet weak var respondByLbl: UILabel!
    
    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var respondButton: UIButton!
    
    //MARK:- Properties
    weak var delegate: AlertsTableViewCellProtocol?
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0,
                                                                     left: 0,
                                                                     bottom: 10,
                                                                     right: 0))
    }
    
    var item: Alarm? {
        didSet {
            let color = item?.ecg_color_code?.hexStringToUIColor()
            contentView.backgroundColor = color
            
            serialNoLbl.text = "\(item?.id ?? 0)"
            nameLbl.text = item?.name
            
            locationLbl.isHidden = true
            alarmAtLbl.isHidden = true
            alarmByLbl.isHidden = true
            respondTimeLbl.isHidden = true
            respondByLbl.isHidden = true
            
            if let location = item?.details?.location {
                locationLbl.isHidden = false
                locationLbl.text = (location.name ?? "") + ": " + (location.value ?? "")
            }
            if let alarmBy = item?.details?.alarm_by {
                alarmByLbl.isHidden = false
                alarmByLbl.text = (alarmBy.name ?? "") + ": " + (alarmBy.value ?? "")
            }
            if let alarmTriggeredAt = item?.details?.alarm_triggered_at {
                alarmAtLbl.isHidden = false
                alarmAtLbl.text = (alarmTriggeredAt.name ?? "") + ": " + (alarmTriggeredAt.value ?? "")
            }
            
            respondButton.setTitleColor(color, for: .normal)
            
            respondButton.isHidden = !(item?.should_show_action_btn ?? false)
            ignoreButton.isHidden = !(item?.should_show_action_btn ?? false)
        }
    }
    
    //MARK:- UI Actions
    @IBAction func didTapIgnoreButton(_ sender: Any) {
        if let item {
            delegate?.didTapIgnorebutton(item: item)
        }
    }
    
    @IBAction func didTapRespondButton(_ sender: Any) {
        if let item {
            delegate?.didTapRespondbutton(item: item)
        }
    }
}
