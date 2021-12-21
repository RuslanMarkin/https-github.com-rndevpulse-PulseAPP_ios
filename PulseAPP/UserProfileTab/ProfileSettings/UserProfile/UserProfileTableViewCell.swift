//
//  UserProfileTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 21.12.2021.
//

import UIKit

protocol UserProfileTableViewCellDelegate: AnyObject {
    func transitionToUserProfile()
}

class UserProfileTableViewCell: UITableViewCell {
    
    weak var delegate: UserProfileTableViewCellDelegate?
    
    let identifier = "UserProfileTableViewCell"
    
    @IBOutlet var userProfileButton: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "UserProfileTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func userProfileButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.userProfileButton.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
            self.userProfileButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
    }
    
}
