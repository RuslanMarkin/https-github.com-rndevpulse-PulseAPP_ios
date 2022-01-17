//
//  ToolMenuCategorySwitchTableViewCell.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 17.01.2022.
//

import UIKit

protocol ToolMenuCategorySwitchTableViewCellDelegate: AnyObject {
    func didSwitchChangedIn(cell: ToolMenuCategorySwitchTableViewCell)
}

class ToolMenuCategorySwitchTableViewCell: UITableViewCell {
    
    static let identifier = "ToolMenuCategorySwitchTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ToolMenuCategorySwitchTableViewCell", bundle: nil)
    }
    
    weak var delegate: ToolMenuCategorySwitchTableViewCellDelegate?
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchTapped() {
        self.delegate?.didSwitchChangedIn(cell: self)
    }
    
}
