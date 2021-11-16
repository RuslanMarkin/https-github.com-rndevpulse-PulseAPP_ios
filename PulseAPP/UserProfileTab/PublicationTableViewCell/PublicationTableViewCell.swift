//
//  PublicationTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 19.10.2021.
//

import UIKit

class PublicationTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "PublicationTableViewCell"
    
    //var imagesOfPublication = [UIImage]()
    var imagesOfPublication: [UIImage] = [UIImage(named: "0.png"), UIImage(named: "1.png"), UIImage(named: "2.png")].compactMap({ $0 })
    
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
        return imagesOfPublication.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: imagesOfPublication[indexPath.row])
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
            if let imagesURLs = getImagesURLs(for: publication) {
                print(imagesURLs)
                for i in imagesURLs.indices {
                    ImageAPIController.shared.getImage(withURL: imagesURLs[i]) { result in
                        DispatchQueue.main.async {
                        switch result {
                                    case .success(let image):
                                        self.imagesOfPublication.append(image)
                                    case .failure(let error):
                                        print(error)
                                    }
                        }
                    }
                }
            }
            collectionView.reloadData()
                
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

    func createLayout() -> UICollectionViewCompositionalLayout{
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalStackItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalStackGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)), subitem: verticalStackItem, count: 2)
        
        let tripleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let tripleHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)), subitem: tripleItem, count: 3)
        
        //group
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(2/3)), subitems: [item, verticalStackGroup])
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), subitems: [horizontalGroup, tripleHorizontalGroup])
        
    //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(3/5)), subitems: [item, verticalStackGroup])
        
        //section
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        //return
        return UICollectionViewCompositionalLayout(section: section)
    }

