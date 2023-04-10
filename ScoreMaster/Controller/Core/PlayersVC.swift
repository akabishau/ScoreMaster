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
	
	private lazy var fetchedResultsController: NSFetchedResultsController<Player> = {
		let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Player.name), ascending: true)]
		
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		configureTableView()
		fetchPlayers()
	}
	
	
	private func fetchPlayers() {
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("Unable to Perform Fetch Request")
			print("\(error), \(error.localizedDescription)")
		}
		//TODO: - Add Empty State Logic
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

//MARK: - Table View Data Source
extension PlayersVC: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		guard let section = fetchedResultsController.sections?[section] else {
			return 0
		}
		return section.numberOfObjects
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let player = fetchedResultsController.object(at: indexPath)
		let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseId, for: indexPath) as! PlayerCell
		cell.set(with: player)
		return cell
	}
	
	
	//TODO: - Player can be remove only if they didn't play and games
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		let player = fetchedResultsController.object(at: indexPath)
		managedObjectContext.delete(player)
		
	}
}


//MARK: - Table View Delegate
extension PlayersVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}


//MARK: - Fetch Results Controller Delegate
extension PlayersVC: NSFetchedResultsControllerDelegate {
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
		switch type {
			case .insert:
				if let indexPath = newIndexPath {
					tableView.insertRows(at: [indexPath], with: .fade)
				}
			case .delete:
				if let indexPath = indexPath {
					tableView.deleteRows(at: [indexPath], with: .fade)
				}
			case .move:
				if let indexPath = indexPath {
					tableView.deleteRows(at: [indexPath], with: .fade)
				}
				if let indexPath = newIndexPath {
					tableView.insertRows(at: [indexPath], with: .fade)
				}
			case .update:
				if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? PlayerCell {
					let player = fetchedResultsController.object(at: indexPath)
					cell.set(with: player)
				}
				
			@unknown default:
				fatalError("Uknown type of NSFetchedResultsChangeType")
		}
	}
}
