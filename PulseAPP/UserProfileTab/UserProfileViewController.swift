//
//  UserProfileViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 13.10.2021.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate {
    
    private var pullControl = UIRefreshControl()
    
    @IBOutlet weak var table: UITableView!
    
    var publications = [UserPublication]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(PublicationTableViewCell.nib(), forCellReuseIdentifier: PublicationTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        

        pullControl.attributedTitle = NSAttributedString(string: "Reload data")
                pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
                if #available(iOS 10.0, *) {
                    self.table.refreshControl = pullControl
                } else {
                    self.table.addSubview(pullControl)
                }
        
        
//        PublicationAPIController.shared.getPublications(ofType: "PUBLICATIONTYPE.Publication", ofCategories: [
//            "PUBLICATIONCATEGORY.Food",
//            "PUBLICATIONCATEGORY.Monument",
//            "PUBLICATIONCATEGORY.Design"
//        ], afterPublicationWithLastId: "2713c5ae-a94d-4a9d-ac84-b58d08fd90b7", with: 0) { result in
//            DispatchQueue.main.async {
//                switch result {
//                            case .success(let userPublications):
//                                self.updateUI(with: userPublications!)
//                            case .failure(let error):
//                                print(error)
//                            }
//                }
//        }
//
        PublicationAPIController.shared.getMyPublications(withUserId: AuthUserData.shared.userId, withToken: AuthUserData.shared.accessToken, withCoef: 0) { result in
            DispatchQueue.main.async {
            switch result {
                        case .success(let userPublications):
                            self.updateUI(with: userPublications!)
                        case .failure(let error):
                            print(error)
                        }
            }
        }
    }
    
    @objc private func refreshListData(_ sender: Any) {
        self.table.reloadData()
        self.pullControl.endRefreshing() // You can stop after API Call
            // Call API
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    func updateUI(with userPublications: [UserPublication]) {
        DispatchQueue.main.async {
            self.publications = userPublications
            self.table.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.publications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: PublicationTableViewCell.identifier, for: indexPath) as! PublicationTableViewCell
        cell.configureTableCell(with: self.publications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderView.instantiate()
    
        let userId = AuthUserData.shared.userId
        let userToken = AuthUserData.shared.accessToken
        APIController.shared.getUserPreview(withid: userId) {
            (result) in DispatchQueue.main.async {
                switch result {
                case .success(let userPreviewData):
                    view.publicNameLabel.text = userPreviewData.publicName
                    view.userNameLabel.text = userPreviewData.name
                    view.countPublicationsLabel.text = "\(NSLocalizedString("Publications: ", comment: "")) \(userPreviewData.countPublications)"
                    view.countPublicationsLabel.adjustsFontSizeToFitWidth = true
                    view.countSubscriptionsLabel.text = "\(NSLocalizedString("Subscriptions: ", comment: ""))  \(userPreviewData.countUsersSubscription)"
                    view.countSubscriptionsLabel.adjustsFontSizeToFitWidth = true
                case .failure(let error):
                    print(error)
                }
            }
        }
        APIController.shared.getUserAvatarURL(withToken: userToken) {
            (result) in DispatchQueue.main.async {
                switch result {
                case .success(let userPhoto):
                    ImageAPIController.shared.getUserAvatarImage(withUrl: userPhoto.url) {
                        (result) in DispatchQueue.main.async {
                            switch result {
                            case .success(let image):
                                view.avatarImage.image = image
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
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
