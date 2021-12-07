//
//  CategoryCollectionTableViewCell.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 24.11.2021.
//

import UIKit

protocol CategoryCollectionTableViewCellDelegate: AnyObject {
    func didTap(with chosenCategories: [String])
}

class CategoryCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "CategoryCollectionTableViewCell"
    
    weak var delegate: CategoryCollectionTableViewCellDelegate?
    
    @IBOutlet var collectionView: UICollectionView!
    
    var publicationCategories = [PublicationCategories]()
    
    var chosenCategories = [String]() //Category ids array for http request
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        
        PublicationAPIController.shared.getPublicationCategories() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let publicationCategories):
                    self.updateUI(with: publicationCategories)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        // Initialization code
    }
    
    func updateUI(with categories: [PublicationCategories]) {
        self.publicationCategories = categories
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publicationCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.configure(with: NSLocalizedString(publicationCategories[indexPath.row].name!, comment: ""))
        cell.layer.cornerRadius = 20.0
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.systemBlue.cgColor
//        if indexPath.row == 0 {
//            cell.isSelected = true
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenCategories.append(publicationCategories[indexPath.row].id!)
        delegate?.didTap(with: chosenCategories)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        chosenCategories = chosenCategories.filter { $0 != publicationCategories[indexPath.row].id}
        delegate?.didTap(with: chosenCategories)
    }
    
}
