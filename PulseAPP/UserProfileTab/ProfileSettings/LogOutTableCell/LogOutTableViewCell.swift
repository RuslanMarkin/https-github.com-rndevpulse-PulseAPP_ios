//
//  LogOutTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 08.12.2021.
//

import UIKit

protocol LogOutTableViewCellDelegate: AnyObject {
    func logOut()
}

class LogOutTableViewCell: UITableViewCell {
    
    weak var delegate: LogOutTableViewCellDelegate?
    
    static let identifier = "LogOutTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "LogOutTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var logOutButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.logOutButton.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
            self.logOutButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        delegate?.logOut()
    }
    
}
