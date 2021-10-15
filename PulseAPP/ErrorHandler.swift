//
//  ErrorHandler.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 13.10.2021.
//

import Foundation

public enum ErrorHandler: Error {
    
    case badRequest(Int, String)
    case responseOk
    
    func handleCode(errorCode: ErrorHandler) {
        switch (errorCode) {
        case .badRequest(let code, let message):
            print("code: \(code)")
            print("message: \(message)")
        case .responseOk:
            break
        }
    }
}
