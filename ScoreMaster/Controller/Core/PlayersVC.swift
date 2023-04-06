//
//  PlayersVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 3/30/23.
//

import UIKit

class PlayersVC: UIViewController {
		
	private let tableView = UITableView()
	private var players: [Player] = []
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		configureTableView()
		getPlayers()
	}
	
	
	private func getPlayers() {
		PersistenceManager.retrievePlayers { [weak self] result in
			guard let self = self else { return }
			switch result {
				case .success(let players):
					self.players = players
					self.tableView.reloadData()
				case .failure(let error):
					print("Error retrieving players: \(error.localizedDescription)")
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
		return players.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseId, for: indexPath) as! PlayerCell
		cell.set(with: players[indexPath.row])
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
		players.append(player)
		if let error = PersistenceManager.save(players: players) {
			players.removeLast() // undo previously appended local array of players
			print("Alert: Couldn't save the player. Error: \(error)")
		} else {
			print("New User Saved")
			tableView.reloadData()
		}
	}
}
