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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

//User authorization
    @IBAction func OKButtonTapped(_ sender: Any) {
        if let login = loginTextField.text, let password = passwordTextField.text {
            APIController.shared.authentication(withlogin: login, password: password) {
                (userData) in
                DispatchQueue.main.async {
                    if let userData = userData {
                        print(userData)
// Что делать с токеном и userId после авторизации?
                    }
                }
            }
        }
    }
}

