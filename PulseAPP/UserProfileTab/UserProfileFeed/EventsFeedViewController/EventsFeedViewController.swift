//
//  EventsFeedViewController.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 23.12.2021.
//

import UIKit

class EventsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    private var pullControl = UIRefreshControl()
    
    var publications = [UserPublication]()
    var lastId: String?
    var pageCoef: Int = 0
    var selectedCategories: [String]?
    var selectedRegions: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(PublicationTableViewCell.nib(), forCellReuseIdentifier: PublicationTableViewCell.identifier)
        table.register(UserProfileTableViewCell.nib(), forCellReuseIdentifier: UserProfileTableViewCell.identifier)
        
        //table.register
        table.delegate = self
        table.dataSource = self
        
        pullControl.attributedTitle = NSAttributedString(string: "Reload data")
                pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
                if #available(iOS 10.0, *) {
                    self.table.refreshControl = pullControl
                } else {
                    self.table.addSubview(pullControl)
                }
        
        selectedCategories = Database.shared.queryCategoriesStatus()
        selectedRegions = Database.shared.queryRegionCodes()
        PublicationAPIController.shared.getPublications(ofType: "PUBLICATIONTYPE.Event", ofCategories: selectedCategories ?? [], inRegions: selectedRegions ?? ["0001001C"], afterPublicationWithLastId: "", with: self.pageCoef, pagination: false) { result in
            DispatchQueue.main.async {
                switch result {
                            case .success(let userPublications):
                                self.updateUI(with: userPublications!)
                                self.pageCoef += 1
                                //print(userPublications)
                            case .failure(let error):
                                print(error)
                            }
                }
        }
    }
    
    @objc private func refreshListData(_ sender: Any) {
        publications.removeAll()
        self.pageCoef = 0
        print(selectedRegions)
        
        selectedCategories = Database.shared.queryCategoriesStatus()
        selectedRegions = Database.shared.queryRegionCodes()
        print(selectedRegions)
        
        PublicationAPIController.shared.getPublications(ofType: "PUBLICATIONTYPE.Event", ofCategories: selectedCategories ?? [], inRegions: selectedRegions ?? ["0001001C"], afterPublicationWithLastId: "", with: self.pageCoef, pagination: false) { result in
            DispatchQueue.main.async {
                switch result {
                            case .success(let userPublications):
                                print(userPublications!.count)
                                self.updateUI(with: userPublications!)
                                self.pageCoef += 1
                            case .failure(let error):
                                print(error)
                            }
                }
        }
        //self.table.reloadData()
        self.pullControl.endRefreshing() // You can stop after API Call
            // Call API
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    func updateUI(with userPublications: [UserPublication]) {
        DispatchQueue.main.async {
            self.publications.append(contentsOf: userPublications)
            self.lastId = self.publications.last?.publication?.id
            self.table.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.publications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: PublicationTableViewCell.identifier, for: indexPath) as! PublicationTableViewCell
        cell.configureTableCell(with: self.publications[indexPath.row+1]) //Fatal error at refreshing data by pulling feed down
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func createSpinner() -> UIView {
        let spinner = UIActivityIndicatorView()
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.table.frame.width, height: 80))
        footerView.addSubview(spinner)
        spinner.center = footerView.center
        spinner.startAnimating()
        
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffY = scrollView.contentOffset.y
        if contentOffY > abs(table.frame.size.height - scrollView.contentSize.height - 80) {
            guard !PublicationAPIController.shared.isPaginating else {
                return // we already fetched more data
            }

            self.table.tableFooterView = createSpinner()
            
            PublicationAPIController.shared.getPublications(ofType: "PUBLICATIONTYPE.Event", ofCategories: selectedCategories ?? [], inRegions: selectedRegions ?? ["0001001C"], afterPublicationWithLastId: ((self.lastId != nil) ? self.lastId! : ""), with: self.pageCoef, pagination: true) { result in
                DispatchQueue.main.async {
                    switch result {
                                case .success(let userPublications):
                                    self.updateUI(with: userPublications!)
                                    self.pageCoef += 1
                                case .failure(let error):
                                    print(error)
                                }
                    }
            }
            self.table.tableFooterView?.isHidden = true

//            PublicationAPIController.shared.getMyPublications(withUserId: AuthUserData.shared.userId, withToken: AuthUserData.shared.accessToken, withCoef: 0, postLastId: ((self.lastId != nil) ? self.lastId! : ""), pagination: true) { result in
//                DispatchQueue.main.async {
//                    self.table.tableFooterView = nil
//                }
//                switch result {
//                case .success(let userPublications):
//                    self.updateUI(with: userPublications!)
//                case .failure(let error):
//                    print(error)
//                }
//            }
            print("fetch more")
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
