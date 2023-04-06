//
//  PlayersVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 3/30/23.
//

import UIKit

class PlayersVC: UIViewController {
		
	private let tableView = UITableView()
	private let dataManager = DataManager.shared
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		configureTableView()
		loadSamplePlayers()
	}
	
	
	private func loadSamplePlayers() {
		if dataManager.players.isEmpty {
			if let path = Bundle.main.path(forResource: "Players", ofType: "json") {
				do {
					let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
					dataManager.players = try JSONDecoder().decode([Player].self, from: data)
					if let error = PersistenceManager.savePlayers() {
						dataManager.players = []
						print("Alert: Couldn't save Players Sample. Error: \(error)")
					} else {
						print("Players added from local json")
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
	
	
	
	private func configureTableView() {
		view.addSubview(tableView)
		tableView.frame = view.bounds
		tableView.rowHeight = 80
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.register(PlayerCell.self, forCellReuseIdentifier: PlayerCell.reuseId)
	}
	
	
	private func configureViewController() {
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		navigationItem.rightBarButtonItem = addButton
	}
	
	
	@objc private func addButtonTapped() {
		let addPlayerVC = AddPlayerVC()
		addPlayerVC.delegate = self
		let navigationController = UINavigationController(rootViewController: addPlayerVC)
		present(navigationController, animated: true)
	}
}


extension PlayersVC: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataManager.players.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseId, for: indexPath) as! PlayerCell
		cell.set(with: dataManager.players[indexPath.row])
		return cell
	}
}

extension PlayersVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}


extension PlayersVC: AddPlayerVCDelegate {
	
	func didAddPlayer(_ player: Player) {
		dataManager.players.append(player)
		if let error = PersistenceManager.savePlayers() {
			dataManager.players.removeLast()
			print("Alert: Couldn't save the player. Error: \(error)")
		} else {
			print("New User Saved")
			tableView.reloadData()
		}
	}
}
