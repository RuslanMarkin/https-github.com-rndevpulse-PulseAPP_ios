//
//  AppDelegate.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Timer.scheduledTimer(timeInterval: (60.0 * 4.0), target: self, selector: #selector(self.doThisEvery5sec), userInfo: nil, repeats: true)
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @objc func doThisEvery5sec () {
        //print("Ok")
        let db = Database()
        let (login, password) = db.queryLoginPassword()
        APIController.shared.authentication(withlogin: login, password: password) {
            (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userData):
                    AuthUserData.shared = userData
                    print("Got token success")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}

