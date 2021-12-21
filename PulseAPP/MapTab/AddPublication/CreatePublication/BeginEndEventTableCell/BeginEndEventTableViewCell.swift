//
//  BeginEndEventTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 02.12.2021.
//

import UIKit

protocol BeginEndEventTableViewCellDelegate: AnyObject {
    func sendEventStartDate(startDate: Date)
    
    func sendEventEndDate(endDate: Date)
}

class BeginEndEventTableViewCell: UITableViewCell {
    
    static let identifier = "BeginEndEventTableViewCell"
    
    weak var delegate: BeginEndEventTableViewCellDelegate?
    
    @IBOutlet weak var eventStartDatePicker: UIDatePicker!
    @IBOutlet weak var eventEndDatePicker: UIDatePicker!
    @IBOutlet weak var eventStartLabel: UILabel!
    @IBOutlet weak var eventFinishLabel: UILabel!
    
    
    static func nib() -> UINib {
        return UINib(nibName: "BeginEndEventTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        eventStartLabel.text = NSLocalizedString("Event starts:", comment: "")
        eventFinishLabel.text = NSLocalizedString("Event finishes", comment: "")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    func configureDatePickers() {
        let startDate = Date()
        let endDate = Date(timeInterval: 3600, since: startDate)
        eventEndDatePicker.setDate(endDate, animated: false)
        eventStartDatePicker.minimumDate = startDate
        eventEndDatePicker.minimumDate = startDate
        delegate?.sendEventStartDate(startDate: startDate)
        delegate?.sendEventEndDate(endDate: endDate)
    }
    
    @IBAction func eventStartPickerChanged(_ sender: UIDatePicker) {
        delegate?.sendEventStartDate(startDate: sender.date)
        eventEndDatePicker.minimumDate = eventStartDatePicker.date
    }
    @IBAction func eventEndPickerChanged(_ sender: UIDatePicker) {
        delegate?.sendEventEndDate(endDate: sender.date)
    }
    
}
