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
                    cities?[indexPath.row].isChecked = nil
                    selectedCitiesCount -= 1
                    
                    selectedRegionNames = selectedRegionNames.filter { $0 != "\(selectedRegion!), \(cities![indexPath.row].name!)" }
                } else {
                    selectedRegionCodes.append(selectedRegionCode!)
                    selectedRegions.append(cities![indexPath.row])
                    selectedRegionCode?.removeLast(4)
                    cities?[indexPath.row].isChecked = true
                    selectedCitiesCount += 1
                    
                    selectedRegion! += ", \(cities![indexPath.row].name!)"
                    selectedRegionNames.append(selectedRegion!)
                    selectedRegion! = selectedRegion!.replacingOccurrences(of: ", \(cities![indexPath.row].name!)", with: "")
                }
            }
        }
        tableView.reloadData()
    }
}

class CityTableViewController: UITableViewController {
    
    var cities: [RegionData]?
    var selectedRegionCode: String?
    var selectedRegionCodes = [String]()
    var selectedRegions = [RegionData]()
    var selectedRegion: String?
    var selectedRegionNames = [String]()
    
    var selectedCitiesCount: Int = 0 {
        didSet {
            if selectedCitiesCount > 2 {
                isAllListShown = false
            } else {
                isAllListShown = true
            }
        }
    }
    
    var isAllListShown: Bool = true
    
    weak var delegate: RegionCodeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        tableView.register(RegionCodeTableViewCell.nib(), forCellReuseIdentifier: RegionCodeTableViewCell.identifier)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "UnwindToToolMenu", sender: nil)
    }
    
//    override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//
//        if parent == nil {
//            self.performSegue(withIdentifier: "UnwindSegueToToolMenu", sender: nil)
//        }
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegionCodeTableViewCell.identifier, for: indexPath) as! RegionCodeTableViewCell
        if isAllListShown {
            if let cityName = cities?[indexPath.row].name {
                if let cityIsChecked = cities?[indexPath.row].isChecked {
                    cell.configure(with: cityName, unavailable: false, isChecked: true)
                } else {
                    cell.configure(with: cityName, unavailable: false, isChecked: false)
                }
            }
        } else {
            if let cityName = cities?[indexPath.row].name {
                if let cityIsChecked = cities?[indexPath.row].isChecked {
                    cell.configure(with: cityName, unavailable: false, isChecked: true)
                } else {
                    cell.configure(with: cityName, unavailable: true, isChecked: false)
                }
            }
        }
        cell.accessoryType = UITableViewCell.AccessoryType.none
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if let cityCode = cities?[indexPath.row].code {
//            self.selectedRegionCode? += cityCode
//            self.performSegue(withIdentifier: "UnwindSegueToToolMenu", sender: nil)
//        }
//
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
