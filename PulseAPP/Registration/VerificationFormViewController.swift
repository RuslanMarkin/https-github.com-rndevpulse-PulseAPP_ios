//
//  VerificationFormViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import UIKit

class VerificationFormViewController: UIViewController {

    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var invalidInputLabel: UILabel!
    
    var authUserData: AuthUserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(LoginPassword.shared.telNumber)
        print(LoginPassword.shared.password)
        self.invalidInputLabel.isHidden = true
        verificationTextField.addTarget(self, action: #selector(VerificationFormViewController.checkTextField(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func checkTextField(_ textfield: UITextField) {
        if let code = textfield.text {
            if let count = textfield.text?.count {
                if count > 5 {
                    APIController.shared.userVerification(withCode: code) { (result) in
                        DispatchQueue.main.async {
                            switch result {
                                case .success(_ ):
                                if LoginPassword.shared.telNumber.count > 0 {
                                    APIController.shared.authentication(withlogin: LoginPassword.shared.telNumber, password: LoginPassword.shared.password) { (result) in
                                            DispatchQueue.main.async {
                                                switch result {
                                                    case .success(let userData):
                                                        textfield.textColor = UIColor.green
                                                        AuthUserData.shared = userData
                                                        self.performSegue(withIdentifier: "UserRegisterSegue", sender: self)
                                                    case .failure(_ ):
                                                        showMessage(in: self.invalidInputLabel, with: "Server error")
                                                }
                                            }
                                    }
                                } else {
                                    print("no login and password")
                                }
                                    
                                case .failure(let error):
                                    showMessage(in: self.invalidInputLabel, with: "Invalid code")
                                    print(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UserRegisterSegue" {
//            let tabBarController = segue.destination as! MainGlobeTabBarController
//            let navController = tabBarController.viewControllers![0] as! UINavigationController
//            let vc = navController.topViewController as! UserProfileViewController
//            vc.authUserData = self.authUserData
//
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
