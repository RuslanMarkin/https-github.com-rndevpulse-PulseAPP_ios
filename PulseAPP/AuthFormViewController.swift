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
    
//    var timerTest : Timer?
//
//    func startTimer () {
//      guard timerTest == nil else { return }
//
//      timerTest =  Timer.scheduledTimer(
//          timeInterval: TimeInterval(600.0),
//          target      : self,
//          selector    : #selector(UIViewController.sendRequest),
//          userInfo    : nil,
//          repeats     : true)
//    }
//
//    func stopTimerTest() {
//      timerTest?.invalidate()
//      timerTest = nil
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invalidLoginLabel.isHidden = true
        
//        NotificationCenter.default.addObserver(AuthFormViewController.self, selector: #selector(UITableView.reloadData), name: AuthUserData.tokenUpdatedNotification, object: nil)
        // Do any additional setup after loading the view.
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
                        AuthUserData.shared = userData
                        self.performSegue(withIdentifier: "UserAuthSegue", sender: nil)
                    case .failure(let error):
                        showMessage(in: self.invalidLoginLabel, with: NSLocalizedString(error.detail, comment: ""))
                        print(error)
// Что делать с токеном и userId после авторизации?
                    }
                }
            }
        } else {
            showMessage(in: invalidLoginLabel, with: "Empty fields")
        }
    }
//    @objc func sendRequest() {
//        APIController.shared.authentication(withlogin: LoginPassword.shared.telNumber, password: LoginPassword.shared.password) {
//            (result) in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let userData):
//                    AuthUserData.shared = userData
//                case .failure(let error):
////                    self.stopTimerTest()
////                    //call function that logs out
////                    let story = UIStoryboard(name: "Main", bundle: nil)
////                    guard let controller = story.instantiateViewController(withIdentifier: "AuthViewController") as? AuthFormViewController else {
////                        return
////                    }
////                    self.navigationController?.pushViewController(controller, animated: true)
//                    showMessage(in: self.invalidLoginLabel, with: NSLocalizedString(error.detail, comment: ""))
//                }
//            }
//        }
//    }
}


