//
//  CityTableViewController.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 25.01.2022.
//

import UIKit

extension CityTableViewController: ToolMenuRadioButtonRegionCodeTableViewCellDelegate {
    func radioButtonChecked(in cell: RegionCodeTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let cityCode = cities?[indexPath.row].code {
                selectedRegionCode! += cityCode
                if selectedRegionCodes.contains(selectedRegionCode!) {
                    selectedRegionCodes = selectedRegionCodes.filter({ code in
                        code != selectedRegionCode!
                    })
                    selectedRegions = selectedRegions.filter { $0.code != cityCode }
                    selectedRegionCode?.removeLast(4)
                } else {
                    selectedRegionCodes.append(selectedRegionCode!)
                    selectedRegions.append(cities![indexPath.row])
                    selectedRegionCode?.removeLast(4)
                }
            }
            //print(selectedRegions)
        }
    }
}

class CityTableViewController: UITableViewController {
    
    var cities: [RegionData]?
    var selectedRegionCode: String?
    var selectedRegionCodes = [String]()
    var selectedRegions = [RegionData]()
    
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
            delegate?.sendToToolMenu(regions: selectedRegions)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegionCodeTableViewCell.identifier, for: indexPath) as! RegionCodeTableViewCell
        if let cityName = cities?[indexPath.row].name {
            cell.configure(with: cityName)
            cell.accessoryType = UITableViewCell.AccessoryType.none
            cell.delegate = self
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cityCode = cities?[indexPath.row].code {
            self.selectedRegionCode? += cityCode
            self.performSegue(withIdentifier: "UnwindSegueToToolMenu", sender: nil)
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
