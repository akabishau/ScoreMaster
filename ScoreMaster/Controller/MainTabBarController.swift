//
//  ViewController.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 3/29/23.
//

import UIKit

class MainTabBarController: UITabBarController {
	
	let coreDataManager = CoreDataManager(modelName: "ScoreMaster")

	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureAppAppearance()
		viewControllers = [createOverviewNC(), createPlayersNC(), createGamesNC(), createStatsNC(), createLeagueNC(),]
	}
	
	
	private func createOverviewNC() -> UINavigationController {
		let overviewVC = OverviewVC()
		overviewVC.title = "Score Master"
		overviewVC.view.backgroundColor = .systemBackground
		overviewVC.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(systemName: "aqi.medium"), tag: 0)
		return UINavigationController(rootViewController: overviewVC)
	}
	

	private func createPlayersNC() -> UINavigationController {
		let playersVC = PlayersVC()
		playersVC.title = "Players"
		playersVC.view.backgroundColor = .systemBackground
		playersVC.tabBarItem = UITabBarItem(title: "Players", image: UIImage(systemName: "person.2"), tag: 1)
		return UINavigationController(rootViewController: playersVC)
	}
	
	
	private func createGamesNC() -> UINavigationController {
		let gamesVC = GamesVC()
		gamesVC.title = "Games"
		gamesVC.view.backgroundColor = .systemBackground
		gamesVC.tabBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller"), tag: 2)
		return UINavigationController(rootViewController: gamesVC)
	}
	
	
	private func createStatsNC() -> UINavigationController {
		let statsVC = StatsVC()
		statsVC.title = "Stats"
		statsVC.view.backgroundColor = .systemBackground
		statsVC.tabBarItem = UITabBarItem(title: "Stats", image: UIImage(systemName: "chart.bar.doc.horizontal"), tag: 3)
		return UINavigationController(rootViewController: statsVC)
	}
	
	
	private func createLeagueNC() -> UINavigationController {
		let leaguesVC = LeaguesVC()
		leaguesVC.title = "Leagues"
		leaguesVC.view.backgroundColor = .systemBackground
		leaguesVC.tabBarItem = UITabBarItem(title: "Leagues", image: UIImage(systemName: "person.3"), tag: 4)
		return UINavigationController(rootViewController: leaguesVC)
	}
	
	
	private func configureAppAppearance() {
		UITabBar.appearance().tintColor = .systemPink
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
	}
}

