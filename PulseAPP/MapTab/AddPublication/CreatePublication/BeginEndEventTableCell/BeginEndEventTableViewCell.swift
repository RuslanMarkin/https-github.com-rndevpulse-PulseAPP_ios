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
    
    
    static func nib() -> UINib {
        return UINib(nibName: "BeginEndEventTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let startDate = Date()
        let endDate = Date(timeInterval: 3600, since: startDate)
        eventEndDatePicker.setDate(endDate, animated: false)
        print(eventStartDatePicker.date.description)
        print(eventEndDatePicker.date.description)
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
    }
    
    @IBAction func eventStartPickerChanged(_ sender: UIDatePicker) {
        delegate?.sendEventStartDate(startDate: sender.date)
    }
    @IBAction func eventEndPickerChanged(_ sender: UIDatePicker) {
        delegate?.sendEventEndDate(endDate: sender.date)
    }
    
}
