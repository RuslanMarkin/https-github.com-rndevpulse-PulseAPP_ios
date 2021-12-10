//
//  PublicationTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 19.10.2021.
//

import UIKit

class PublicationTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "PublicationTableViewCell"
    
    var imageURLs: [String]?
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
        collectionView.contentInsetAdjustmentBehavior = .never
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesOfPublication.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: imagesOfPublication[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 250)
    }
    
    func configureTableCell(with publicationForCell: UserPublication?) {
        
        if let publication = publicationForCell {
            
            let isoDate = publication.publication!.datePublication!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
            
            if let date = dateFormatter.date(from: isoDate) {
                let localdate = date.toLocalTime()
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.setLocalizedDateFormatFromTemplate("dd-MM-yyyy : hh:mm")
                self.publicationTime.text = dateFormatter.string(from: localdate)
            }
            self.orgOrUserPublicName.text = publication.user!.publicName
            self.publicationDescriptionLabel.text = publication.publication!.description
            
            APIController.shared.getUserAvatarURL(withToken: AuthUserData.shared.accessToken) {
                (result) in DispatchQueue.main.async {
                    switch result {
                    case .success(let userPhoto):
                        ImageAPIController.shared.getUserAvatarImage(withUrl: userPhoto.url) {
                            (result) in DispatchQueue.main.async {
                                switch result {
                                case .success(let image):
                                    self.publicationUserAvatar.image = image
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            if let imageURLs = getImagesURLs(for: publication) {
                self.imagesOfPublication.removeAll()
                    for i in imageURLs.indices {
                        print(imageURLs[i])
                        ImageAPIController.shared.getImage(withURL: imageURLs[i]) { result in
                            DispatchQueue.main.async {
                            switch result {
                                        case .success(let image):
                                            self.imagesOfPublication.append(image)
                                        case .failure(let error):
                                            print(error)
                                        }
                            self.collectionView.reloadData()
                            }
                        }
                    }
                
            }
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

