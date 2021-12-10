//
//  ImagesTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 10.12.2021.
//

import UIKit

class ImagesTableViewCell: UITableViewCell {
    
    static let identifier = "ImagesTableViewCell"

    @IBOutlet weak var publicationImageView: UIImageView!
    @IBOutlet weak var imageDescriptionLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "ImagesTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for item: String, with image: UIImage) {
        if item == "PUBLICATIONTYPE.Organization" {
            imageDescriptionLabel.text = NSLocalizedString("Org. logo:", comment: "")
            publicationImageView.image = image.resizeImage(to: CGSize(width: 80, height: 80))
        } else {
            imageDescriptionLabel.text = NSLocalizedString("Photo:", comment: "")
            publicationImageView.image = image.resizeImage(to: CGSize(width: 80, height: 80))
        }
        
    }
    
}
