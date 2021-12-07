//
//  CoverageRadiusTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 03.12.2021.
//

import UIKit

protocol CoverageRadiusTableViewCellDelegate: AnyObject {
    func sliderDidChange(with value: Int)
}

class CoverageRadiusTableViewCell: UITableViewCell {
    
    static let identifier = "CoverageRadiusTableViewCell"
    
    weak var delegate: CoverageRadiusTableViewCellDelegate?
    
    @IBOutlet weak var coverageRadiusSlider: UISlider!
    @IBOutlet weak var sliderStartingPointLabel: UILabel!
    @IBOutlet weak var sliderCurrentValueLabel: UILabel!
    @IBOutlet weak var sliderEndingPointLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "CoverageRadiusTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        sliderStartingPointLabel.text = "0 m"
        sliderEndingPointLabel.text = "1000 m"
        sliderCurrentValueLabel.text = String(Int(round(coverageRadiusSlider.value * 1000))) + " m"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func sliderValueChanged(_ sender: Any) {
        let value = Int(round(coverageRadiusSlider.value * 1000))
        sliderCurrentValueLabel.text = String(value) + " m"
        delegate?.sliderDidChange(with: value)
    }
    
}
