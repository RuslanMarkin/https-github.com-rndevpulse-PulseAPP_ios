//
//  AddPublicationViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 19.11.2021.
//

import UIKit

class AddPublicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var publicationTypes = [PublicationType]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        PublicationAPIController.shared.getPublicationTypes() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let publicationTypes):
                    self.updateUI(with: publicationTypes)
                case .failure(let error):
                    print(error)
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func updateUI(with publicationTypes: [PublicationType]) {
        self.publicationTypes = publicationTypes
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicationTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublicationTypeCell", for: indexPath)
        cell.textLabel?.text = publicationTypes[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped \(publicationTypes[indexPath.row])")
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
