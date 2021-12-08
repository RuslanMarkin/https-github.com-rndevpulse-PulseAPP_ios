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
        performSegue(withIdentifier: "LogOutSegue", sender: nil)
    }
}

class ProfileSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.register(LogOutTableViewCell.nib(), forCellReuseIdentifier: LogOutTableViewCell.identifier)
//        Database.shared.delete()
//        table.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: LogOutTableViewCell.identifier, for: indexPath) as! LogOutTableViewCell
        cell.delegate = self
        cell.logOutButton.setTitle("Log out", for: .normal)
        return cell
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
