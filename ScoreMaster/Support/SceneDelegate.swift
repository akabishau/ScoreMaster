//
//  SceneDelegate.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 3/29/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: windowScene)
		window.rootViewController = MainTabBarController()
		window.makeKeyAndVisible()
		self.window = window
	}
}

