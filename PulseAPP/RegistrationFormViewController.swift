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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        if let userName = userNameTextField.text, let password = passwordTextField.text, let telNumber = telNumberTextField.text, let email = emailTextField.text {
            APIController.shared.registration(withlogin: userName, password: password, telNumber: telNumber, email: email) {
                (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let regisData):
                        print(regisData)
                        self.performSegue(withIdentifier: "VerificationSegue", sender: nil)
                    case .failure(let error):
                        self.invalidInputLabel.alpha = 1
                        self.invalidInputLabel.isHidden = false
                        self.invalidInputLabel.text = "Wrong login"
                        UIView.animate(withDuration: 1.0, animations: { () -> Void in
                            self.invalidInputLabel.alpha = 0
                        })
                        print(error)
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
