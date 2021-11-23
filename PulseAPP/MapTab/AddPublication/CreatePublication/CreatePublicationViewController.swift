//
//  CreatePublicationViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 22.11.2021.
//

import UIKit
import CoreLocation

class CreatePublicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //var locManager = CLLocationManager()
    //locManager.requestWhenInUseAuthorization()
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(ImageAndDescriptionTableViewCell.nib(), forCellReuseIdentifier: ImageAndDescriptionTableViewCell.identifier)
        
//        table.register(CodedTableViewCell.self, forCellReuseIdentifier: CodedTableViewCell.identifier)
        
        return table
    }()
    
    var selectedImage = UIImage()
    //var publicationType: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageAndDescriptionTableViewCell.identifier, for: indexPath) as! ImageAndDescriptionTableViewCell
        cell.configure(with: selectedImage)
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
