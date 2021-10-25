//
//  ViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import UIKit

class AuthFormViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidLoginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invalidLoginLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

//User authorization
    @IBAction func OKButtonTapped(_ sender: Any) {
        if let login = loginTextField.text, let password = passwordTextField.text {
            APIController.shared.authentication(withlogin: login, password: password) {
                (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let userData):
                        AuthUserData.shared = userData
                        self.performSegue(withIdentifier: "UserAuthSegue", sender: nil)
                    case .failure(let error):
                        showMessage(in: self.invalidLoginLabel, with: "Wrong login")
                        print(error)
// Что делать с токеном и userId после авторизации?
                    }
                }
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UserAuthSegue" {
//            let tabBarController = segue.destination as! MainGlobeTabBarController
//            let navController = tabBarController.viewControllers![0] as! UINavigationController
//            let vc = navController.topViewController as! UserProfileViewController
//            vc.authUserData = self.userData
//        }
//    }
}

