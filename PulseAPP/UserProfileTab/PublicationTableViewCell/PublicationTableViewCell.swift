//
//  PublicationTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 19.10.2021.
//

import UIKit

class PublicationTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "PublicationTableViewCell"
    
    let urlconst = URL(string: "http://192.168.1.100/api/v1/files/images/c39bdee2-6db7-4c62-8c51-284d4500d629.jpg?size=small")!
    
    var imagesOfPublication = [UIImage]()
    
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
        return self.imagesOfPublication.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: urlconst)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
    
    func configureTableCell(with publicationForCell: UserPublication?) {
        if let publication = publicationForCell {
            self.orgOrUserPublicName.text = publication.user!.publicName
            self.publicationTime.text = publication.publication!.datePublication
            self.publicationDescriptionLabel.text = publication.publication!.description
//            if let imagesUrls = getImagesURLs(for: publication) {
//                
//                updateTableCell(with: imagesUrls)
//            }
        }
    }
    
    func getImagesURLs(for publication: UserPublication?) -> [String]? {
        if let publication = publication, let imagesURLs = publication.files {
                return imagesURLs
        } else {
                return nil
        }
    }
}

//func updateTableCell(with urls: [String]) {
//
//    urls.map { (url) -> UIImage? in
//        ImageAPIController.shared.getImage(withURL: url) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let image):
//                    return image
//                case .failure(let error):
//                    print(error)
//                    return nil
//                }
//            }
//        }
//    }
//}
