//
//  SceneDelegate.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        //Repeating activity for token refresh
        Timer.scheduledTimer(timeInterval: (60.0), target: self, selector: #selector(self.refreshToken), userInfo: nil, repeats: true)
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    //Function resfreshing token
    @objc func refreshToken () {
        
        let (login, password) = Database.shared.queryLoginPassword()
        print("\(login) | \(password)")
        APIController.shared.authentication(withlogin: login, password: password) {
            (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userData):
                    Database.shared.updateUserData(with: userData.accessToken)
                //    Database.shared.insertUserData(userId: userData.userId, login: login, password: password, token: userData.accessToken)
                // How to replace db row?
                    AuthUserData.shared = userData
                    print("Got token success")
                case .failure(_):
                    print("Couldn't log in")

                    if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as? AuthFormViewController {
                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            if !AuthFormViewController.isShown {
                                currentController.show(controller, sender: self)
                                controller.navigationItem.hidesBackButton = true
                                AuthFormViewController.isShown = true
                            }
                        }
                    }
                }
            }
        }
    }
}

