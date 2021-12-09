//
//  NameTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 02.12.2021.
//

import UIKit

class NameTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "NameTableViewCell"

    let nameTextField: UITextField = {
        let nameTextField = UITextField()
        return nameTextField
    }()
    
    public func configure() {
        contentView.addSubview(nameTextField)
        nameTextField.placeholder = NSLocalizedString("Name", comment: "")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameTextField.frame = CGRect(x: 5, y: 5, width: UIScreen.main.bounds.width, height: 50)
    }

}
