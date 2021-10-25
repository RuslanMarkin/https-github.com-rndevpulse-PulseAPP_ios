//
//  PublicationTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 19.10.2021.
//

import UIKit

class PublicationTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "PublicationTableViewCell"
    var publications = [Publication]()
    
    @IBOutlet weak var publicationTime: UILabel!
    @IBOutlet weak var orgOrUserPublicName: UILabel!
    @IBOutlet weak var publicationUserAvatar: UIImageView!
    @IBOutlet weak var publicationDescriptionLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    static func nib() -> UINib {
        return UINib(nibName: "PublicationTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: UIImage(named: "\(indexPath.row).png")!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
    
//    func configureTableCell(with publicationForCell: FetchedPublication) {
//        self.orgOrUserPublicName.text = publicationForCell.user.publicName
//        self.publicationTime.text = publicationForCell.publication.datePublication
//        self.publicationDescriptionLabel.text = publicationForCell.publication.description
//    }
}
