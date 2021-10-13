//
//  VerificationFormViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import UIKit

class VerificationFormViewController: UIViewController {

    @IBOutlet weak var verificationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
///    verificationTextField.addTarget(self, action: #selector(VerificationFormViewController.checkTextField(_:)), for: .valueChanged)
    
    @objc func checkTextField(_ textfield: UITextField) {
        
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
