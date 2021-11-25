//
//  CreatePublicationViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 22.11.2021.
//

import UIKit
import CoreLocation

class CreatePublicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var locManager = CLLocationManager()
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(ImageAndDescriptionTableViewCell.nib(), forCellReuseIdentifier: ImageAndDescriptionTableViewCell.identifier)
        
        table.register(CategoryCollectionTableViewCell.nib(), forCellReuseIdentifier: CategoryCollectionTableViewCell.identifier)
        
        return table
    }()
    
    //Properties for sending request to server
    var selectedImage = UIImage()
    var publicationDescription: String?
    var geoposition: String?
    var publicationCategories: [String]?
    var publicationTypeId: String?
    //var publicationType: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locManager.desiredAccuracy = kCLLocationAccuracyBest //battery
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    @IBAction func sharePublicationButtonTapped(_ sender: Any) {
        
    }
    @IBAction func unwindToCreatePublication(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GeoDataViewController {
            geoposition = sourceViewController.geoposition!
        }
        self.tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            geoposition = "\(location.coordinate.latitude), \(location.coordinate.longitude)"

        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageAndDescriptionTableViewCell.identifier, for: indexPath) as! ImageAndDescriptionTableViewCell
            cell.configure(with: selectedImage)
            return cell
        case 1:
            guard let geoposition = geoposition else {
                let cell = UITableViewCell()
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "Add geoposition"
                return cell
            }
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = geoposition
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCollectionTableViewCell.identifier, for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: 50, height: 30)
        label.text = "New publication"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        
        let constraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[label]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["label": label])

        label.addConstraints(constraint)
                
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            geoposition = nil
            performSegue(withIdentifier: "GeoSegue", sender: nil)
        default:
            return
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
