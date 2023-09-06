//
//  AppDelegate.swift
//  fireBaseApp
//
//  Created by macbook on 13.08.2023.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UIViewController()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.showModalAuth()
            }else{
               self.showModalController()
            }
        }
        return true
    }
    func showModalAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newvc = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        window?.rootViewController = newvc
    }
  func showModalController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newvc = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        window?.rootViewController = newvc
    }
}

