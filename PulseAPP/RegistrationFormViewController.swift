//
//  RegistrationFormViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import UIKit

class RegistrationFormViewController: UIViewController {
    
    //var regisUserData: RegistrationUserData

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var telNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var invalidInputLabel: UILabel!
    var loginPassword = LoginPassword(login: "", password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invalidInputLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        if let userName = userNameTextField.text, let password = passwordTextField.text, let telNumber = telNumberTextField.text, let email = emailTextField.text {
            LoginPassword.shared.login = telNumber
            LoginPassword.shared.password = password
            print(loginPassword.login)
            print(loginPassword.password)
            APIController.shared.registration(withlogin: userName, password: password, telNumber: telNumber, email: email) {
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
            showMessage(in: self.invalidInputLabel, with: "Some field is empty")
   //Add some logic if textfields of registration form are empty
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
