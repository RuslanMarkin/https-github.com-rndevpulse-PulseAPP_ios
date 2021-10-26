//
//  RegistrationFormViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import UIKit

class RegistrationFormViewController: UIViewController, UITextFieldDelegate {
    
    //var regisUserData: RegistrationUserData

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var telNumberTextField: UITextField!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var invalidInputLabel: UILabel!
    var loginPassword = LoginPassword(telNumber: "", password: "")
    var countryReceivedCode: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invalidInputLabel.isHidden = true
        countryButton.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToRegistration(unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? CountryViewController {
            countryReceivedCode = sourceViewController.countryChosen
        }
        if let country = countryReceivedCode {
            self.countryButton.setTitle("+\(country)", for: .normal)
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        if let userName = userNameTextField.text, !userName.isEmpty, let password = passwordTextField.text, !password.isEmpty, let telNumber = telNumberTextField.text, !telNumber.isEmpty, let email = emailTextField.text, !email.isEmpty {
            if let countryCode = countryReceivedCode, userName.containsValidCharacter {
                LoginPassword.shared.telNumber = "+" + countryCode + telNumber
                LoginPassword.shared.password = password
                print(loginPassword.telNumber)
                print(loginPassword.password)
                APIController.shared.registration(withlogin: userName, password: password, telNumber: LoginPassword.shared.telNumber, email: email) {
                    (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let regisData):
                            print(regisData)
                            self.performSegue(withIdentifier: "VerificationSegue", sender: nil)
                        case .failure(let error):
                            showMessage(in: self.invalidInputLabel, with: "Wrong login")
                            print(error)
                        }
                    }
                }
            } else {
                showMessage(in: self.invalidInputLabel, with: "Incorrect input")
       //Add some logic if textfields of registration form are empty
            }
        } else {
            showMessage(in: self.invalidInputLabel, with: "Some field is empty")
        }
    }
    
    @objc func countryButtonTapped() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = story.instantiateViewController(withIdentifier: "CountryViewController") as? CountryViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
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

extension String {

var containsValidCharacter: Bool {
    guard self != "" else { return true }
    let hexSet = CharacterSet(charactersIn: "^[abcdefghijklmnopqrstuvwxyzAEIOUBCDFGHJKLMNPQRSTVXZWY0123456789-'_.~]+$")
    let newSet = CharacterSet(charactersIn: self)
    return hexSet.isSuperset(of: newSet)
  }
}
