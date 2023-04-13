//
//  LeagueDetailsVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import UIKit
import CoreData

class LeagueDetailsVC: UIViewController {
	
	private let tableView = UITableView()
	private var league: League
	
	init(league: League) {
		self.league = league
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	//MARK: - FtchedResultsController
	private lazy var fetchedResultsController: NSFetchedResultsController<Player> = {
		
		guard let managedObjectContext = self.league.managedObjectContext else {
			fatalError("No Managed Object Context Found")
		}
		
		let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Player.name), ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "ANY leagues == %@", league)
		
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("Unable to Perform Fetch Request")
			print("\(error), \(error.localizedDescription)")
		}
		return fetchedResultsController
	}()

	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureTableView()
		configureViewController()
	}
	
	
	
	private func configureViewController() {
		title = league.name
		view.backgroundColor = .systemBackground
		
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		navigationItem.rightBarButtonItem = addButton
	}
	
	
	@objc private func addButtonTapped() {
		let vc = AddNewPlayerToLeagueVC()
		vc.league = league
		let nc = UINavigationController(rootViewController: vc)
		present(nc, animated: true)
		
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


extension LeagueDetailsVC: UITableViewDataSource {
	
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
}

extension LeagueDetailsVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}


extension LeagueDetailsVC: NSFetchedResultsControllerDelegate {

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}


	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}



	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

		switch type {
			case .insert:
				print("insert")
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
				print("update")
				if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? PlayerCell {
					let player = fetchedResultsController.object(at: indexPath)
					cell.set(with: player)
				}

			default:
				fatalError("Uknown type of NSFetchedResultsChangeType")
		}
	}

}

