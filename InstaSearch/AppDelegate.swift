//
//  AppDelegate.swift
//  InstaSearch
//
//  Created by Danya on 28.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import UIKit
import CoreData

var loginToInstgram: Bool {
	get {
		let login = UserDefaults.standard.bool(forKey: "login.instagram")
		return login
	}
	set {
		UserDefaults.standard.set(newValue, forKey: "login.instagram")
		UserDefaults.standard.synchronize()
	}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		if loginToInstgram {
			self.window?.rootViewController = rootViewController()
		}
		return true
	}

	func rootViewController() -> UIViewController {
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let VC = storyboard.instantiateViewController(withIdentifier:
			String.init(describing: InstaPhotosViewController.self)) as! InstaPhotosViewController
		let navVC = UINavigationController.init(rootViewController: VC)
		return navVC
	}
	
	func applicationWillResignActive(_ application: UIApplication) {

	}

}

