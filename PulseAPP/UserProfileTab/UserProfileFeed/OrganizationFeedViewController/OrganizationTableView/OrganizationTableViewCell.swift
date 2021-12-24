//
//  OrganizationTableViewCell.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 24.12.2021.
//

import UIKit

class OrgTableViewCell: UITableViewCell {
    
    static let identifier = "OrgTableViewCell"
    
    @IBOutlet weak var orgLogoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var webSiteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var likesCounterLabel: UILabel!
    @IBOutlet weak var viewsCounterLabel: UILabel!
    @IBOutlet weak var pulseCounterLabel: UILabel!
    @IBOutlet weak var commentsCounterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "OrgTableViewCell", bundle: nil)
    }
    
    func configureCell(with publication: UserPublication?) {
        if let publication = publication?.publication {
            if let caption = publication.caption {
                nameLabel.text = caption
            }
            if let description = publication.description {
                descriptionLabel.text = description
            }
            if let address = publication.address {
                addressLabel.text = address
            }
            if let webSite = publication.website {
                webSiteLabel.text = webSite
            }
            if let phone = publication.phone {
                phoneLabel.text = phone
            }
            
            if let counter = publication.countLikes {
                self.likesCounterLabel.text = "♥️" + String(counter)
            }
            if let counter = publication.countViews {
                self.viewsCounterLabel.text = "👀" + String(counter)
            }
            if let counter = publication.countPulse {
                self.pulseCounterLabel.text = "🔴" + String(counter)
            }
            if let counter = publication.countComments {
                self.commentsCounterLabel.text = "📃" + String(counter)
            }
        }
        
        if let avatarURL = publication?.files?.first {
            ImageAPIController.shared.getImage(withURL: avatarURL) {
                    (result) in DispatchQueue.main.async {
                        switch result {
                        case .success(let userPhoto):
                                self.orgLogoImageView.image = userPhoto
                        case .failure(let error):
                                print(error)
                        }
                    }
            }
        } else {
            self.orgLogoImageView.image = UIImage(named: "default")
        }
    }
    
}
