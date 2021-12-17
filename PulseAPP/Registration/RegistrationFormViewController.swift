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
    var activeTextField: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismissing keyboard by tapping outside its area
        //Looks for single or multiple taps.
             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        
        //Checking if e-mail textfied is used to move view up, because it is overlapped by keyboard
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(RegistrationFormViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
            NotificationCenter.default.addObserver(self, selector: #selector(RegistrationFormViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        invalidInputLabel.isHidden = true
        countryButton.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }

//    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.activeTextField = textField
//    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
        if activeTextField == emailTextField {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
//       activeTextField = nil
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
        if activeTextField == emailTextField {
            self.view.frame.origin.y = 0
        }
        activeTextField = nil
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
