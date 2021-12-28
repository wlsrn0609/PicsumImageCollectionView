//
//  AppDelegate.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var naviCon : UINavigationController?
    var mainVC : MainViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        mainVC = MainViewController()
        mainVC?.viewModel = MainViewModel()
        naviCon = UINavigationController(rootViewController: mainVC!)

        window?.rootViewController = naviCon

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }

   
}

