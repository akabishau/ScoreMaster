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
		
		configureTableView()
		getPlayers()
	}
	
	
	private func getPlayers() {
		if let path = Bundle.main.path(forResource: "Players", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				players = try JSONDecoder().decode([Player].self, from: data)
				tableView.reloadData()
				
			} catch {
				print("Error decoding local JSON file: \(error)")
			}
		} else {
			print("Local JSON file not found.")
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
