//
//  CheckBox.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 26.01.2022.
//

import Foundation
import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "ic_check_box")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
    let unavailableCheck = UIImage(named: "ic_check_box_unavailable")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    func setCheckBoxUnavailable() {
        self.setImage(unavailableCheck, for: UIControl.State.normal)
    }
    
    func setCheckBoxAvailable() {
        self.setImage(uncheckedImage, for: UIControl.State.normal)
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
