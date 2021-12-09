//
//  DescriptionTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 08.12.2021.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell, UITextViewDelegate {
    
    static let identifier = "DescriptionTableViewCell"
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    static func nib() -> UINib {
        return UINib(nibName: "DescriptionTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.textColor = .lightGray
        descriptionTextView.text = NSLocalizedString("Description", comment: "")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.text = nil
//        textView.textColor = .black
//    }
}
