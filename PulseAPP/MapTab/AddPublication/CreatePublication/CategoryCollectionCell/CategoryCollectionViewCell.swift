//
//  CategoryCollectionViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 24.11.2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var label: UILabel!
    
    static let identifier = "CategoryCollectionViewCell"
    
    override var isSelected: Bool {
            didSet {
                if self.isSelected {
                    backgroundColor = UIColor.systemBlue
                }
                else {
                    backgroundColor = UIColor.white
                }
            }
        }
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        label.layer.cornerRadius = 5.0
//        label.layer.borderColor = UIColor.systemBlue.cgColor
//        label.layer.borderWidth = 3.0
        // Initialization code
    }
    
    public func configure(with text: String) {
        label.text = text
    }

}
