//
//  CollectionViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 18.10.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    
    static let identifier = "PhotoCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with image: UIImage) {
        photoImageView.image = image
    }

}
