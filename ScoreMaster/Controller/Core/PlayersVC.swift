//
//  PlayersVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 3/30/23.
//

import UIKit
import CoreData

class PlayersVC: UIViewController {
		
	private let tableView = UITableView()
	var managedObjectContext: NSManagedObjectContext!
	
	var players: [Player] = []
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		configureTableView()
//		loadSamplePlayers()
		setupNotificationHandling()
		fetchNotes()
	}
	
	
	private func fetchNotes() {
		print(#function)
		// Create Fetch Request
		let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
		// Configure Fetch Request
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Player.name), ascending: false)]
		
		managedObjectContext.performAndWait {
			do {
				let players = try fetchRequest.execute()
				self.players = players
				self.tableView.reloadData()
			} catch {
				let fetchError = error as NSError
				print("Unable to Execute Fetch Request")
				print("\(fetchError), \(fetchError.localizedDescription)")
			}
		}
	}
	
	
	private func setupNotificationHandling() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(_:)), name: NSManagedObjectContext.didChangeObjectsNotification, object: managedObjectContext)
		
	}
	
	@objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
		print(#function)
		
		guard let userInfo = notification.userInfo else { return }
		
		var playersDidChange = false
		
		if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
			for insert in inserts {
				if let player = insert as? Player {
					players.append(player)
					playersDidChange = true
				}
			}
		}
		
		if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
			for update in updates {
				if let _ = update as? Player {
					playersDidChange = true
				}
			}
		}
		
		if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
			for delete in deletes {
				if let player = delete as? Player {
					if let index = players.firstIndex(of: player) {
						players.remove(at: index)
						playersDidChange = true
					}
				}
			}
		}
		
		if playersDidChange {
			players.sort { player1, player2 in
				return player1.name! < player2.name!
			}
			tableView.reloadData()
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
		addPlayerVC.managedObjectContext = managedObjectContext
		
		//TODO: is this a valid scenario? Change to push/pop
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
	
	
	//TODO: - Player can be remove only if they didn't play and games
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		managedObjectContext.delete(players[indexPath.row])
		
	}
}

extension PlayersVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
