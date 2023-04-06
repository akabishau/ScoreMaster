//
//  LeaguesVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import UIKit

class LeaguesVC: UIViewController {
	
	private let tableView = UITableView()
	private let dataManager = DataManager.shared
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureTableView()
		loadSampleLeagues()
	}
	
	
	
	private func configureTableView() {
		view.addSubview(tableView)
		tableView.frame = view.bounds
		tableView.rowHeight = 80
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyle")
	}
	
	
	private func loadSampleLeagues() {
		if dataManager.leagues.isEmpty {
			if let path = Bundle.main.path(forResource: "Leagues", ofType: "json") {
				do {
					let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
					dataManager.leagues = try JSONDecoder().decode([League].self, from: data)
					if let error = PersistenceManager.saveLeagues() {
						dataManager.leagues = []
						print("Alert: Couldn't save Leagues Sample. Error: \(error)")
					} else {
						print("Leagues added from local json")
						tableView.reloadData()
					}
				} catch {
					print("Error decoding local JSON file: \(error)")
				}
			} else {
				print("Local JSON file not found.")
			}
		}
	}
}



extension LeaguesVC: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataManager.leagues.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
		cell.textLabel?.text = dataManager.leagues[indexPath.row].name
		return cell
	}
}

extension LeaguesVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let detailsVC = LeagueDetailsVC(league: dataManager.leagues[indexPath.row])
		navigationController?.pushViewController(detailsVC, animated: true)
	}
}
