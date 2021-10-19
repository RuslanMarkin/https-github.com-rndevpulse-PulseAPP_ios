//
//  ViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import UIKit

class AuthFormViewController: UIViewController {
    
    var userData: AuthUserData?

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
                        self.userData = userData
                        self.performSegue(withIdentifier: "UserAuthSegue", sender: nil)
                    case .failure(let error):
                        self.invalidLoginLabel.alpha = 1
                        self.invalidLoginLabel.isHidden = false
                        self.invalidLoginLabel.text = "Wrong login"
                        UIView.animate(withDuration: 1.0, animations: { () -> Void in
                            self.invalidLoginLabel.alpha = 0
                        })
                        print(error)
// Что делать с токеном и userId после авторизации?
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserAuthSegue" {
            let tabBarController = segue.destination as! MainGlobeTabBarController
            let navController = tabBarController.viewControllers![0] as! UINavigationController
            let vc = navController.topViewController as! UserProfileViewController
            vc.authUserData = userData
        }
    }
}

