//
//  ErrorHandler.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 13.10.2021.
//

import Foundation
import UIKit

public enum ErrorHandler: Error {
    
    case badRequest(Int, String)
    case imageNotFound(Int)
    case couldntFetchPublications(Int, String)
    case responseOk
    
    func handleCode(errorCode: ErrorHandler) {
        switch (errorCode) {
        case .badRequest(let code, let message):
            print("code: \(code)")
            print("message: \(message)")
        case .imageNotFound(let code):
            print("code: \(code)")
        case .couldntFetchPublications(let code, let message):
            print("code: \(code)")
            print("message: \(message)")
        case .responseOk:
            break
        }
    }
}

func showMessage(in label: UILabel, with message: String) {
    label.alpha = 1
    label.isHidden = false
    label.text = message
    UIView.animate(withDuration: 1.0, animations: { () -> Void in
        label.alpha = 0
    })
}
