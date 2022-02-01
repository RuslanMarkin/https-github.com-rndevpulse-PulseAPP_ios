//
//  RegionFilterTableViewController.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 24.01.2022.
//

import UIKit

extension RegionFilterTableViewController: ToolMenuRadioButtonRegionCodeTableViewCellDelegate {
    func radioButtonChecked(in cell: RegionCodeTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let country = regions?[indexPath.row] {
                if selectedRegions.contains(country) {
                    selectedRegions = selectedRegions.filter { $0 != country }
                    selectedRegionCodes = selectedRegionCodes.filter { $0 != country.code! }
                } else {
                    selectedRegions.append(country)
                    selectedRegionCodes.append(country.code!)
                }
                print(selectedRegions)
            }
        }
    }
}

extension RegionFilterTableViewController: RegionCodeDelegate {
    func sendToToolMenu(regions: [RegionData]) {
        //print("returned to tool menu")
        selectedRegions.append(contentsOf: regions)
        //print(selectedRegions)
    }
}

protocol RegionCodeSendDelegate: AnyObject {
    func sendToToolMenu(regions: [RegionData])
}

class RegionFilterTableViewController: UITableViewController {
    
    var regions: [RegionData]?
    var areas: [RegionData]?
    var selectedRegions = [RegionData]()
    var selectedRegion: RegionData?
    var selectedRegionCode: String?
    var selectedRegionCodes = [String]()
    
    weak var delegate: RegionCodeSendDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        tableView.register(RegionCodeTableViewCell.nib(), forCellReuseIdentifier: RegionCodeTableViewCell.identifier)
        
        RegionFilterAPIController.shared.fetchRegionsToFilter(searchArea: "", resultType: "country") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let regions):
                    self.updateUI(with: regions)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        

//         Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false
//
//         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
//    override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//
//        if parent == nil {
//            delegate?.sendToToolMenu(regions: selectedRegions)
//        }
//    }
    
    func updateUI(with regions: [RegionData]) {
        DispatchQueue.main.async {
            self.regions = regions
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegionCodeTableViewCell.identifier, for: indexPath) as! RegionCodeTableViewCell
        if let countryName = regions?[indexPath.row].name {
            cell.configure(with: countryName, unavailable: false, isChecked: false)
            cell.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedRegions.isEmpty {
            if let region = regions?[indexPath.row] {
                selectedRegion = region
                selectedRegionCode = region.code!
                RegionFilterAPIController.shared.fetchRegionsToFilter(searchArea: region.code!, resultType: "area") { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let areas):
                            self.areas = areas
                            self.performSegue(withIdentifier: "AreaSegue", sender: nil)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        } else {
            print("Array is not empty")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AreaSegue" {
            let secondVC: AreaTableViewController = segue.destination as! AreaTableViewController
            secondVC.delegate = self
            secondVC.areas = areas
            secondVC.selectedRegions = selectedRegions
            secondVC.selectedRegionCode = selectedRegionCode
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
