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
    
    //Outlets for likes, views, comments and pulse counters labels
    @IBOutlet weak var likesCounterLabel: UILabel!
    @IBOutlet weak var viewsCounterLabel: UILabel!
    @IBOutlet weak var pulseCounterLabel: UILabel!
    @IBOutlet weak var commentsCounterLabel: UILabel!
    
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
        return CGSize(width: UIScreen.main.bounds.width, height: 228)
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
            
            if let counter = publication.publication!.countLikes {
                self.likesCounterLabel.text = "♥️" + String(counter)
            }
            if let counter = publication.publication!.countViews {
                self.viewsCounterLabel.text = "👀" + String(counter)
            }
            if let counter = publication.publication!.countPulse {
                self.pulseCounterLabel.text = "🔴" + String(counter)
            }
            if let counter = publication.publication!.countComments {
                self.commentsCounterLabel.text = "📃" + String(counter)
            }
            
            if let publicationUser = publication.user, let imageURL = publicationUser.data {
                ImageAPIController.shared.getImage(withURL: imageURL) {
                    (result) in DispatchQueue.main.async {
                        switch result {
                        case .success(let userPhoto):
                                self.publicationUserAvatar.image = userPhoto
                        case .failure(let error):
                                print(error)
                        }
                    }
                }
            }
            
            if let imageURLs = getImagesURLs(for: publication) {
                let dispatchGroup = DispatchGroup()
                self.imagesOfPublication.removeAll()
                    for i in imageURLs.indices {
                        dispatchGroup.enter()
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
                        dispatchGroup.leave()
                    }
                dispatchGroup.notify(queue: .main) {
                    if self.imagesOfPublication.isEmpty {
                        //print("no images")
                    } else {
                        //print("images appended")
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

