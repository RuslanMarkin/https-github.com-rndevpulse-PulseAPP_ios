//
//  RegionCodeTableViewCell.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 26.01.2022.
//

import UIKit

protocol ToolMenuRadioButtonRegionCodeTableViewCellDelegate: AnyObject {
    func radioButtonChecked(in cell: RegionCodeTableViewCell) 
}

class RegionCodeTableViewCell: UITableViewCell {
    
    static let identifier = "RegionCodeTableViewCell"
    
    weak var delegate: ToolMenuRadioButtonRegionCodeTableViewCellDelegate?

    @IBOutlet weak var radioButton: CheckBox!
    @IBOutlet weak var regionLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "RegionCodeTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func radioButtonTapped(_ sender: Any) {
        delegate?.radioButtonChecked(in: self)
    }
    
    func configure(with region: String, unavailable: Bool, isChecked: Bool) {
        if unavailable {
            regionLabel.text = region
            regionLabel.textColor = .systemGray
            radioButton.setCheckBoxUnavailable()
            self.isUserInteractionEnabled = false
        } else {
            regionLabel.text = region
            regionLabel.textColor = .black
            radioButton.setCheckBoxAvailable()
            self.isUserInteractionEnabled = true
        }
        if isChecked {
            radioButton.isChecked = true
        } else {
            radioButton.isChecked = false
        }
    }
    
}
