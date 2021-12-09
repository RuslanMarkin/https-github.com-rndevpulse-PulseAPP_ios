//
//  AddPublicationViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 19.11.2021.
//

import UIKit
import Photos
import PhotosUI

class AddPublicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISheetPresentationControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    
    var publicationTypes = [PublicationType]()
    var indexOfSelectedRow: Int?
    
    var selectedImages = [UIImage]()
    var selectedImagesUrls = [String]()
    var selectedImagesExtensions = [String]()
    
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
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        self.selectedImages.removeAll()
        self.selectedImagesUrls.removeAll()
        self.selectedImagesExtensions.removeAll()
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()
        
        DispatchQueue.main.async {
            results.forEach { result in
                group.enter()
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
                        guard let url = url else {
                            return
                        }
                    let urlString = String("\(url)".dropFirst(7))
                    self.selectedImagesUrls.append(urlString)
                    self.selectedImagesExtensions.append(url.pathExtension)
                }
                result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                    defer {
                        group.leave()
                    }
                    guard let image = reading as? UIImage, error == nil else {
                        return
                    }
                    self.selectedImages.append(image)
                }
            }
            group.notify(queue: .main) {
                if !self.selectedImages.isEmpty {
                    self.performSegue(withIdentifier: "CreatePublicationSegue", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreatePublicationSegue" {
            let destinationVC = segue.destination as! CreatePublicationViewController

            destinationVC.selectedImages = selectedImages
            destinationVC.publicationType = publicationTypes[indexOfSelectedRow!]
            destinationVC.imgUrls = selectedImagesUrls
            destinationVC.selectedImagesExtensions = selectedImagesExtensions
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
        indexOfSelectedRow = indexPath.row
        let selectedType = publicationTypes[indexPath.row].name
        tableView.deselectRow(at: indexPath, animated: true)
        
        let imagePickerController = UIImagePickerController()
        
        var config = PHPickerConfiguration(photoLibrary: .shared())
        switch selectedType {
        case "PUBLICATIONTYPE.Publication":
            config.selectionLimit = 10
        case "PUBLICATIONTYPE.Event":
            config.selectionLimit = 10
        case "PUBLICATIONTYPE.Organization":
            config.selectionLimit = 1
        default:
            config.selectionLimit = 1
        }
        config.filter = .images
        
        let photoPickerController = PHPickerViewController(configuration: config)
        photoPickerController.delegate = self
//
        let actionSheet = UIAlertController(title: NSLocalizedString("Photo Source", comment: ""), message: NSLocalizedString("Choose image", comment: ""), preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera is not available")
            }

        }))
//
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default, handler: { (action: UIAlertAction) in
            self.present(photoPickerController, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: 50, height: 30)
        label.text = NSLocalizedString("Create: ", comment: "")
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
