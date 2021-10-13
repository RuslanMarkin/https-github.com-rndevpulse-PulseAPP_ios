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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        if let userName = userNameTextField.text, let password = passwordTextField.text, let telNumber = telNumberTextField.text, let email = emailTextField.text {
            APIController.shared.registration(withlogin: userName, password: password, telNumber: telNumber, email: email) {
                (regisUserData) in
                DispatchQueue.main.async {
                    if let regisUserData = regisUserData {
                        print(regisUserData)
                    }
                }
            }
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
