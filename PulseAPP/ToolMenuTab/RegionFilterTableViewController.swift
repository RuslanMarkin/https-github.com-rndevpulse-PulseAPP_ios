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
                    selectedRegionNames = selectedRegionNames.filter { $0 != regions![indexPath.row].name! }
                } else {
                    selectedRegions.append(country)
                    selectedRegionCodes.append(country.code!)
                    selectedRegionNames.append(regions![indexPath.row].name!)
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
    var selectedRegion: String?
    var selectedRegionCode: String?
    var selectedRegionCodes = [String]()
    var selectedRegionNames = [String]()
    var searchReg = [RegionData] ()
    
    weak var delegate: RegionCodeSendDelegate?

    @IBOutlet weak var searchBar: UISearchBar!
    
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
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "UnwindFromRegionToToolMenu", sender: nil)
    }
    
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
                selectedRegion = region.name!
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
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AreaSegue" {
            let secondVC: AreaTableViewController = segue.destination as! AreaTableViewController
            secondVC.delegate = self
            secondVC.areas = areas
            secondVC.selectedRegions = selectedRegions
            secondVC.selectedRegionCode = selectedRegionCode
            secondVC.selectedRegion = selectedRegion
        }
    }
}
