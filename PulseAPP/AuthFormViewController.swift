//
//  ViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import UIKit

class AuthFormViewController: UIViewController {
    
    static var isShown: Bool = true

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidLoginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismissing keyboard by tapping outside its area
        //Looks for single or multiple taps.
             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        
        invalidLoginLabel.isHidden = true
        print(Database.shared.queryCategory())
        let (login, password) = Database.shared.queryLoginPassword()
            APIController.shared.authentication(withlogin: login, password: password) {
                (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let userData):
                        AuthFormViewController.isShown = false
                        AuthUserData.shared = userData
                        self.performSegue(withIdentifier: "UserAuthSegue", sender: nil)
                    case .failure(let error):
                        showMessage(in: self.invalidLoginLabel, with: NSLocalizedString(error.title, comment: ""))
                        print(error)
                    }
                }
            }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

//User authorization
    @IBAction func OKButtonTapped(_ sender: Any) {
        if let login = loginTextField.text, !login.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            LoginPassword.shared.telNumber = login
            LoginPassword.shared.password = password
            APIController.shared.authentication(withlogin: login, password: password) {
                (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let userData):
                        AuthFormViewController.isShown = false
                        Database.shared.insertUserData(userId: userData.userId, login: login, password: password, token: userData.accessToken)
                        AuthUserData.shared = userData //This row with high posibility will be replaced by //database user_data table refresh
                        self.performSegue(withIdentifier: "UserAuthSegue", sender: nil)
                    case .failure(let error):
                        showMessage(in: self.invalidLoginLabel, with: NSLocalizedString(error.title, comment: ""))
                        print(error)
                    }
                }
            }
            PublicationAPIController.shared.getPublicationCategories() { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let publicationCategories):
                        var id: Int32 = 1
                        for category in publicationCategories {
                            Database.shared.insertCategoryData(id: id, categoryId: category.id!, categoryName: category.name!, isChecked: true)
                            id += 1
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            showMessage(in: invalidLoginLabel, with: "Empty fields")
        }
    }
}


