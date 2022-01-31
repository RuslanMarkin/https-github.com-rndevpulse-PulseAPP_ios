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
        }
    }
}

extension ToolMenuViewController: RegionCodeDelegate {
    func sendToToolMenu(regions: [RegionData]) {
        selectedRegions?.append(contentsOf: regions)
        //self.selectedRegionCodes = selectedRegionCodes
        //print(selectedRegions)
    }
}

class ToolMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(ToolMenuCategorySwitchTableViewCell.nib(), forCellReuseIdentifier: ToolMenuCategorySwitchTableViewCell.identifier)
        table.register(RegionCodeTableViewCell.self, forCellReuseIdentifier: RegionCodeTableViewCell.identifier)
        
        return table
    }()
    
    var categories: [PublicationCategories]? {
        didSet {
            self.countInTable = categories!.count
        }
    }
    var countInTable: Int = 1
    
//    var selectedCodeRegion: String? {
//        didSet {
//            if let selectedCodeRegion = selectedCodeRegion {
//                Database.shared.update(regionCode: selectedCodeRegion, at: 0)
//            }
//        }
//    }
    var selectedRegionCodes: [String]? {
        didSet {
            print(selectedRegionCodes)
        }
    }
    
    var selectedRegions: [RegionData]? {
        didSet {
            print(selectedRegions!)
        }
    }
    
    weak var feedDelegate: UpdateFeeds?
    weak var delegate: RegionCodeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Settings", comment: "")
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        categories = Database.shared.queryCategory()
        Database.shared.createRegionCodeTable()
        Database.shared.insertRegionCodeData(id: 0, regionCode: "0001")
        
        delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let categoriesCount = categories?.count {
//            countInTable += categoriesCount
//        }
        return countInTable + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0...countInTable - 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ToolMenuCategorySwitchTableViewCell.identifier, for: indexPath) as! ToolMenuCategorySwitchTableViewCell
            cell.delegate = self
            if let categories = categories, let categoryName = categories[indexPath.row].name {
                //print(indexPath.row)
                cell.configureCell(with: NSLocalizedString(categoryName, comment: ""))
            }
            return cell
        case countInTable:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegionCodeTableViewCell.identifier, for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Choose region", comment: "")
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case countInTable:
            performSegue(withIdentifier: "RegionFilterSegue", sender: nil)
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegionFilterSegue" {
            let secondVC: RegionFilterTableViewController = segue.destination as! RegionFilterTableViewController
            secondVC.delegate = self
        }
    }
    
    @IBAction func unwindToToolMenu(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? CityTableViewController {
            selectedRegionCodes = sourceVC.selectedRegionCodes
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
