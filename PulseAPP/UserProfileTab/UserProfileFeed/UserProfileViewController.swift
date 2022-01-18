//
//  UserProfileViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 13.10.2021.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var eventsTableView: UIView!
    @IBOutlet weak var publicationsTableView: UIView!
    @IBOutlet weak var organizationTableView: UIView!
    
    var publications = [UserPublication]()
    var lastId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func PublicationTypeSegmentedControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            eventsTableView.alpha = 1
            publicationsTableView.alpha = 0
            organizationTableView.alpha = 0
            //present view controller with events in table view
        } else if sender.selectedSegmentIndex == 1 {
            eventsTableView.alpha = 0
            publicationsTableView.alpha = 1
            organizationTableView.alpha = 0
            //present view controller with publications in table view
        } else if sender.selectedSegmentIndex == 2 {
            eventsTableView.alpha = 0
            publicationsTableView.alpha = 0
            organizationTableView.alpha = 1
            //present view controller with organizations in table view
        }
    }
    
    
}
