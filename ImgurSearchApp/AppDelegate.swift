//
//  AppDelegate.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
//        let simpleNetworkManager = SimpleNetworking()
        
        let searchController = ImageSearchController()
        let navVC = UINavigationController(rootViewController: searchController)
        navVC.navigationBar.isTranslucent = false
        navVC.view.backgroundColor = .systemBackground
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }
}
