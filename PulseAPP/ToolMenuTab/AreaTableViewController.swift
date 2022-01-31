//
//  AreaTableViewController.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 25.01.2022.
//

import UIKit
import AVFoundation

extension AreaTableViewController: ToolMenuRadioButtonRegionCodeTableViewCellDelegate {
    func radioButtonChecked(in cell: RegionCodeTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let areaCode = areas?[indexPath.row].code {
                selectedRegionCode! += areaCode
                if selectedRegionCodes.contains(selectedRegionCode!) {
                    selectedRegionCodes = selectedRegionCodes.filter({ codeForArea in
                        codeForArea != selectedRegionCode!
                    })
                    selectedRegions = selectedRegions.filter { $0.code != areaCode  }
                    selectedRegionCode?.removeLast(4)
                    areas?[indexPath.row].isChecked = nil
                    isAllListShown = true
                } else {
                    selectedRegionCodes.append(selectedRegionCode!)
                    selectedRegions.append(areas![indexPath.row])
                    selectedRegionCode?.removeLast(4)
                    areas?[indexPath.row].isChecked = true
                    isAllListShown = false
                }
                print(selectedRegionCodes)
            }
        }
        tableView.reloadData()
    }
}

extension AreaTableViewController: RegionCodeDelegate {
    func sendToToolMenu(regions: [RegionData]) {
        selectedRegions.append(contentsOf: regions)
        //print(selectedRegions)
    }
}

class AreaTableViewController: UITableViewController {
    
    var areas: [RegionData]?
    var cities: [RegionData]?
    //var selectedRegion: RegionData?
    var selectedRegions = [RegionData]()
    var selectedRegionCode: String?
    var selectedRegionCodes = [String]()
    
    var isAllListShown: Bool = true
    
    weak var delegate: RegionCodeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(RegionCodeTableViewCell.nib(), forCellReuseIdentifier: RegionCodeTableViewCell.identifier)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        if parent == nil {
            //print(selectedRegions)
            delegate?.sendToToolMenu(regions: selectedRegions)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return areas?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegionCodeTableViewCell.identifier, for: indexPath) as! RegionCodeTableViewCell
        if isAllListShown {
            if let areaName = areas?[indexPath.row].name {
                if let areaIsChecked = areas?[indexPath.row].isChecked {
                    cell.configure(with: areaName, unavailable: false, isChecked: true)
                } else {
                    cell.configure(with: areaName, unavailable: false, isChecked: false)
                }
            }
        } else {
            if let areaName = areas?[indexPath.row].name {
                if let areaIsChecked = areas?[indexPath.row].isChecked {
                    cell.configure(with: areaName, unavailable: false, isChecked: true)
                } else {
                    cell.configure(with: areaName, unavailable: true, isChecked: false)
                }
            }
        }
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedRegions.isEmpty {
            if let areaCode = areas?[indexPath.row].code {
                selectedRegionCode? += areaCode
                RegionFilterAPIController.shared.fetchRegionsToFilter(searchArea: areaCode, resultType: "city") { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let cities):
                            self.cities = cities
                            self.performSegue(withIdentifier: "CitySegue", sender: nil)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        } else {
            print("You already selected area: \(selectedRegionCode)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CitySegue" {
            let secondVC: CityTableViewController = segue.destination as! CityTableViewController
            secondVC.delegate = self
            secondVC.cities = cities
            secondVC.selectedRegionCode = selectedRegionCode
            secondVC.selectedRegionCodes = selectedRegionCodes
            secondVC.selectedRegions = selectedRegions
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
