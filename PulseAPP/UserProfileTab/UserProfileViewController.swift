//
//  UserProfileViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 13.10.2021.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(PublicationTableViewCell.nib(), forCellReuseIdentifier: PublicationTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        PublicationAPIController.shared.getMyPublications(withUserId: AuthUserData.shared.userId, withToken: AuthUserData.shared.accessToken, withCoef: 0)
//        {
//            (result) in
//            switch result {
//            case .success(let userPublications):
//                self.publications = userPublications
//            case .failure(let error):
//                print(error)
//            }
//        }
        // Do any additional setup after loading the view.
    }
    
    //func
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2//publications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: PublicationTableViewCell.identifier, for: indexPath) as! PublicationTableViewCell
    //    cell.configureTableCell(with: publications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderView.instantiate()
    
        let userId = AuthUserData.shared.userId
        let userToken = AuthUserData.shared.accessToken
        print(userId)
        APIController.shared.getUserPreview(withid: userId) {
            (result) in DispatchQueue.main.async {
                switch result {
                case .success(let userPreviewData):
                    print(userPreviewData)
                    view.publicNameLabel.text = userPreviewData.publicName
                    view.userNameLabel.text = userPreviewData.name
                    view.countPublicationsLabel.text = String("Publications:  \(userPreviewData.countPublications)")
                    view.countPublicationsLabel.adjustsFontSizeToFitWidth = true
                    view.countSubscriptionsLabel.text = String("Subscriptions: \(userPreviewData.countUsersSubscription)")
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
        return 221
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
