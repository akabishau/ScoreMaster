//
//  LeaguesVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import UIKit
import CoreData

class LeaguesVC: UIViewController {
	
	var managedObjectContext: NSManagedObjectContext!
	
	private lazy var fetchedResultsController: NSFetchedResultsController<League> = {
		
		let fetchRequest: NSFetchRequest<League> = League.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(League.name), ascending: true)]
		
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
	
	
	
	private let tableView = UITableView()
	private var leagues: [League] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		configureTableView()
//		fetchLeagues()
	}
	
	
	private func fetchLeagues() {
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("Unable to Perform Fetch Request")
			print("\(error), \(error.localizedDescription)")
		}
		//TODO: - Add Empty State Logic
	}
	
	
	@objc private func addButtonTapped() {
		let addLeagueVC = AddLeagueVC()
		addLeagueVC.managedObjectContext = managedObjectContext
		//TODO: is this a valid scenario? Change to push/pop
		let navigationController = UINavigationController(rootViewController: addLeagueVC)
		present(navigationController, animated: true)
	}
	
	
	
	private func configureTableView() {
		view.addSubview(tableView)
		tableView.frame = view.bounds
		tableView.rowHeight = 80
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyle")
	}
	
	
	private func configureViewController() {
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		navigationItem.rightBarButtonItem = addButton
	}
}


//MARK: - Table View Data Source
extension LeaguesVC: UITableViewDataSource {
	
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
		let league = fetchedResultsController.object(at: indexPath)
		print("\(league.name ?? "") has \(league.players?.count ?? 0) players")
		let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
		cell.textLabel?.text = league.name
		return cell
	}
}

extension LeaguesVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let league = fetchedResultsController.object(at: indexPath)
		let detailsVC = LeagueDetailsVC(league: league)
		navigationController?.pushViewController(detailsVC, animated: true)
	}
}


//MARK: - Fetch Results Controller Delegate
extension LeaguesVC: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//		print(#function)
		tableView.beginUpdates()
	}
	
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//		print(#function)
		tableView.endUpdates()
	}
	
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//		print(#function)
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
				print("update leagues")
				#warning("work on main/child content")
				if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
					let league = fetchedResultsController.object(at: indexPath)
					cell.textLabel?.text = league.name
				}
				
			@unknown default:
				fatalError("Uknown type of NSFetchedResultsChangeType")
		}
	}
}
