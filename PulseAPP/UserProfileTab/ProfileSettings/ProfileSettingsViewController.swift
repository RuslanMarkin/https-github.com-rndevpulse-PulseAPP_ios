//
//  ProfileSettingsViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 16.11.2021.
//

import UIKit

extension ProfileSettingsViewController: LogOutTableViewCellDelegate {
    func logOut() {
        Database.shared.delete()
        Database.shared.deleteCategories()
        performSegue(withIdentifier: "LogOutSegue", sender: nil)
    }
}

extension ProfileSettingsViewController: UserProfileTableViewCellDelegate {
    func transitionToUserProfile() {
        performSegue(withIdentifier: "UserFeedSegue", sender: nil)
    }
}

class ProfileSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.register(LogOutTableViewCell.nib(), forCellReuseIdentifier: LogOutTableViewCell.identifier)
        table.register(UserProfileTableViewCell.nib(), forCellReuseIdentifier: UserProfileTableViewCell.identifier)
//        Database.shared.delete()
//        table.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: LogOutTableViewCell.identifier, for: indexPath) as! LogOutTableViewCell
            cell.delegate = self
            cell.logOutButton.setTitle(NSLocalizedString("Log out", comment: ""), for: .normal)
            return cell
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: UserProfileTableViewCell.identifier, for: indexPath) as! UserProfileTableViewCell
            cell.delegate = self
            cell.userProfileButton.setTitle("User Profile", for: .normal)
            return cell
        default:
            return UITableViewCell()
        }
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
