//
//  AddPublicationViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 19.11.2021.
//

import UIKit

class AddPublicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISheetPresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var publicationTypes = [PublicationType]()
    
    var selectedImage = UIImage()
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [.medium(), .large()]
        
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
    
    //Code for image picker and to pass selected image to 'create publication view controller'
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.selectedImage = image
        
        picker.dismiss(animated: true, completion: nil)

        performSegue(withIdentifier: "CreatePublicationSegue", sender: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreatePublicationSegue" {
            let destinationVC = segue.destination as! CreatePublicationViewController
//            let index = tableView.indexPathForSelectedRow!.row
//            destinationVC.publicationType = publicationTypes[index].name
            destinationVC.selectedImage = selectedImage
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicationTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublicationTypeCell", for: indexPath)
        cell.textLabel?.text = NSLocalizedString(publicationTypes[indexPath.row].name!, comment: "") 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped \(publicationTypes[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose photo for publication", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera is not available")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: 50, height: 30)
        label.text = "Create: "
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        
        let constraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[label]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["label": label])

        label.addConstraints(constraint)
                
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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