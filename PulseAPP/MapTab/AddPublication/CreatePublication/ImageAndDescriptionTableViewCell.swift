//
//  ImageAndDescriptionTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 22.11.2021.
//

import UIKit

class ImageAndDescriptionTableViewCell: UITableViewCell {
    
    static let identifier = "ImageAndDescriptionTableViewCell"
    
    @IBOutlet var publicationImageView: UIImageView!
    @IBOutlet var descriptionTextField: UITextField!
    
    static func nib() -> UINib {
        return UINib(nibName: "ImageAndDescriptionTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with publicationImage: UIImage) {
        publicationImageView.image = publicationImage.resizeImage(to: CGSize(width: 30.0, height: 30.0))
    }
    
}
