//
//  ToolMenuViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 13.10.2021.
//

import UIKit

protocol UpdateFeeds: AnyObject {
    func updateUsersFeed(with categories: [String]?)
}

extension ToolMenuViewController: ToolMenuCategorySwitchTableViewCellDelegate {
    func didSwitchChangedIn(cell: ToolMenuCategorySwitchTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let switchState = cell.categorySwitch.isOn
            let categoryRow = Int32(indexPath.row)
            Database.shared.update(isActive: switchState, atCategory: categoryRow)
            //delegate?.updateUsersFeed(with: <#T##[String]?#>)
            //print("Switch state is \(cell.categorySwitch.isOn) at \(indexPath.row)")
        }
    }
}

class ToolMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(ToolMenuCategorySwitchTableViewCell.nib(), forCellReuseIdentifier: ToolMenuCategorySwitchTableViewCell.identifier)
        
        return table
    }()
    
    var categories: [PublicationCategories]?
    
    weak var delegate: UpdateFeeds?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Settings", comment: "")
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        categories = Database.shared.queryCategory()
//        if let categories = Database.shared.queryCategory() {
//            print(categories)
//            self.categories?.append(contentsOf: categories)
//        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToolMenuCategorySwitchTableViewCell.identifier, for: indexPath) as! ToolMenuCategorySwitchTableViewCell
        cell.delegate = self
        if let categories = categories, let categoryName = categories[indexPath.row].name {
            cell.configureCell(with: NSLocalizedString(categoryName, comment: ""))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
