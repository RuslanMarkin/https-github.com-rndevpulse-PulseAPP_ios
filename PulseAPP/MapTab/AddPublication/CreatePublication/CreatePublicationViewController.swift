//
//  CreatePublicationViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 22.11.2021.
//

import UIKit
import CoreLocation

extension CreatePublicationViewController: BeginEndEventTableViewCellDelegate {
    
    func sendEventStartDate(startDate: Date) {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let stringDate = iso8601DateFormatter.string(from: startDate)
        self.eventStartDate = stringDate
    }
    
    func sendEventEndDate(endDate: Date) {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let stringDate = iso8601DateFormatter.string(from: endDate)
        self.eventEndDate = stringDate
    }
}

extension CreatePublicationViewController: CoverageRadiusTableViewCellDelegate {
    
    func sliderDidChange(with value: Int) {
        self.coverageRadius = value
    }
}

extension CreatePublicationViewController: CategoryCollectionTableViewCellDelegate {
    
    func didTap(with chosenCategories: [String]) {
        publicationCategories = chosenCategories
    }
}

extension CreatePublicationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    @objc func valueChanged(_ textField: UITextField) {
        self.eventName = textField.text
    }
}

extension CreatePublicationViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.publicationDescription = textView.text
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
    }
}

extension CreatePublicationViewController: GeoDataViewControllerDelegate {
    func sendGeoposition(geo: String) {
        self.geoposition = geo
    }
}

class CreatePublicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(ImageAndDescriptionTableViewCell.nib(), forCellReuseIdentifier: ImageAndDescriptionTableViewCell.identifier)
        
        table.register(CategoryCollectionTableViewCell.nib(), forCellReuseIdentifier: CategoryCollectionTableViewCell.identifier)
        
        table.register(NameTableViewCell.self, forCellReuseIdentifier: NameTableViewCell.identifier)
        
        table.register(BeginEndEventTableViewCell.nib(), forCellReuseIdentifier: BeginEndEventTableViewCell.identifier)
        
        table.register(CoverageRadiusTableViewCell.nib(), forCellReuseIdentifier: CoverageRadiusTableViewCell.identifier)
        
        return table
    }()
    
    //Properties for sending request to server
    var selectedImages = [UIImage]()
    var imgUrls = [String]()
    var selectedImagesExtensions = [String]()
    var publicationDescription: String?
    var geoposition: String? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var publicationCategories: [String]?
    var publicationType: PublicationType!
    var userId: String?
    var fileIds = [String]()
    var regionCode = "344"
    
    //Properties that are used only for event
    var eventName: String?
    var eventStartDate: String?
    var eventEndDate: String?
    var coverageRadius: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.title = "New \(NSLocalizedString(publicationType.name!, comment: ""))"
        
        userId = AuthUserData.shared.userId
        //Uploading images to server by the moment we get createPublicationViewController
        self.uploadImages(with: imgUrls)
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sharePublicationButtonTapped(_ sender: Any) {
        switch publicationType.id {
            case "4b64cfdf-ecaf-430c-491d-08d995241a63": //Publication
            if let userId = userId, let geoposition = geoposition, let publicationCategories = publicationCategories, let publicationDescription = publicationDescription, let publicationTypeId = publicationType.id {
                let publication = PublicationServerUpload(userId: userId, description: publicationDescription, geoposition: geoposition, publicationCategories: publicationCategories, publicationTypeId: publicationTypeId, files: fileIds, regionCode: regionCode)
                PublicationAPIController.shared.upload(publication: publication, with: AuthUserData.shared.accessToken) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let publicationUploadResponse):
                            print(publicationUploadResponse)
                        case .failure(let errorData):
                            print(NSLocalizedString(errorData.detail, comment: ""))
                        }
                    }
                }
            }
            case "69a3ede9-171d-4684-491e-08d995241a63": //Event
                if let userId = userId, let eventName = eventName, let coverageRadius = coverageRadius, let geoposition = geoposition, let publicationCategories = publicationCategories, let publicationDescription = publicationDescription, let publicationTypeId = publicationType.id, let eventStartDate = eventStartDate, let eventEndDate = eventEndDate {
                        let event = EventServerUpload(userId: userId, name: eventName, description: publicationDescription, geoposition: geoposition, publicationCategories: publicationCategories, publicationTypeId: publicationTypeId, files: fileIds, begin: eventStartDate, end: eventEndDate, coverageRadius: coverageRadius, regionCode: regionCode)
                    PublicationAPIController.shared.uploadEvent(event: event, with: AuthUserData.shared.accessToken) { (result) in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let eventUploadResponse):
                                    print(eventUploadResponse)
                                case .failure(let errorData):
                                    print(NSLocalizedString(errorData.detail, comment: ""))
                                }
                            }
                        }
                }
            default:
                print("Hello")
            }
            self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch publicationType.id {
        case "4b64cfdf-ecaf-430c-491d-08d995241a63": //Publication
            return 3
        case "69a3ede9-171d-4684-491e-08d995241a63": //Event
            return 6
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch publicationType.id {
        case "4b64cfdf-ecaf-430c-491d-08d995241a63": //Publication creation
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageAndDescriptionTableViewCell.identifier, for: indexPath) as! ImageAndDescriptionTableViewCell
                cell.publicationImageView.image = nil
                if let selectedImage = selectedImages.first {
                    cell.configure(with: selectedImage)
                }
                cell.descriptionTextView.delegate = self
                return cell
            case 1:
                guard let geoposition = self.geoposition else {
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
                let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCollectionTableViewCell.identifier, for: indexPath) as! CategoryCollectionTableViewCell
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
            }
        case "69a3ede9-171d-4684-491e-08d995241a63": //Event Creation
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: NameTableViewCell.identifier, for: indexPath) as! NameTableViewCell
                cell.configure()
                cell.nameTextField.delegate = self
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageAndDescriptionTableViewCell.identifier, for: indexPath) as! ImageAndDescriptionTableViewCell
                cell.publicationImageView.image = nil
                if let selectedImage = selectedImages.first {
                    cell.configure(with: selectedImage)
                }
                cell.descriptionTextView.delegate = self
                return cell
            case 2:
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
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCollectionTableViewCell.identifier, for: indexPath) as! CategoryCollectionTableViewCell
                cell.delegate = self
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: BeginEndEventTableViewCell.identifier, for: indexPath) as! BeginEndEventTableViewCell
                cell.delegate = self
                cell.configureDatePickers()
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: CoverageRadiusTableViewCell.identifier, for: indexPath) as! CoverageRadiusTableViewCell
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch publicationType.id {
        case "4b64cfdf-ecaf-430c-491d-08d995241a63": //Publication creation
            switch indexPath.row {
            case 0:
                return 100 //Image and description
            case 1:
                return 50 //Geoposition
            case 2:
                return 65 //Categories
            default:
                return 0
            }
        case "69a3ede9-171d-4684-491e-08d995241a63": //Event Creation
            switch indexPath.row {
            case 0:
                return 50
            case 1:
                return 100
            case 2:
                return 50 //Geoposition
            case 3:
                return 65 //Categories
            case 4:
                return 250
            case 5:
                return 110
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch publicationType.id {
        case "4b64cfdf-ecaf-430c-491d-08d995241a63": //Publication creation
            switch indexPath.row {
            case 1:
                geoposition = nil
                performSegue(withIdentifier: "GeoSegue", sender: nil)
            default:
                return
            }
        case "69a3ede9-171d-4684-491e-08d995241a63": //Event Creation
            switch indexPath.row {
            case 2:
                geoposition = nil
                performSegue(withIdentifier: "GeoSegue", sender: nil)
            default:
                return
            }
        default:
            return
        }
    }
    
    func uploadImages(with imgUrls: [String]) {
        let dispatchGroup = DispatchGroup()
        for (i, imageUrl) in imgUrls.enumerated() {
            dispatchGroup.enter()
            print(i)
            print(selectedImagesExtensions[i])
            print(selectedImages.count)
            
//              ImageAPIController.shared.uploadImage(with: AuthUserData.shared.accessToken, pathToFile: imageUrl, fileExtension: selectedImagesExtensions[i], image: selectedImages[i]) { (result) in
//                  DispatchQueue.main.async {
//                      switch result {
//                      case .success(let imageServerData):
//                          self.fileIds.append(imageServerData.id)
//                          print(imageServerData.file)
//                      case .failure(let serverError):
//                          print(NSLocalizedString(serverError.detail, comment: ""))
//                      }
//                  }
//              }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GeoSegue" {
            let secondVC: GeoDataViewController = segue.destination as! GeoDataViewController
            secondVC.delegate = self
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
