//
//  CollectionViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 18.10.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    
    static let identifier = "CollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage) {
//        let images: [UIImage] = [UIImage(named: "0.png"), UIImage(named: "1.png"), UIImage(named: "2.png")].compactMap({ $0 })
        photoImageView.image = image
        contentView.clipsToBounds = true
    }

}

