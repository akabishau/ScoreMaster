//
//  LeagueNewPlayersVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/10/23.
//

import UIKit
import CoreData


class AddNewPlayerToLeagueVC: UIViewController {
	
	private let tableView = UITableView()
	
	var league: League!
	
	private lazy var fetchedResultsController: NSFetchedResultsController<Player> = {
		
		guard let managedObjectContext = self.league.managedObjectContext else {
			fatalError("No Managed Object Context Found")
		}
		
		let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Player.name), ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "NOT (SELF IN %@)", league.players ?? [])
		
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
		
		configureViewController()
		configureTableView()
	}
	
	
	private func configureTableView() {
		view.addSubview(tableView)
		tableView.frame = view.bounds
		tableView.rowHeight = 80
		
		tableView.allowsMultipleSelection = true
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.register(PlayerCell.self, forCellReuseIdentifier: PlayerCell.reuseId)
	}
	
	
	private func configureViewController() {
		view.backgroundColor = .systemBackground
		title = "Select Players for League"
		
		let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
		navigationItem.rightBarButtonItem = saveButton
	}
	
	
	@objc private func saveButtonTapped() {
		guard let selectedIndexes = tableView.indexPathsForSelectedRows else {
			return
		}
		for index in selectedIndexes {
			league.mutableSetValue(forKey: "players").add(fetchedResultsController.object(at: index))
		}
		dismiss(animated: true)
	}
}


//MARK: - Table View Data Source
extension AddNewPlayerToLeagueVC: UITableViewDataSource {
	
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


//MARK: - Table View Delegate
extension AddNewPlayerToLeagueVC: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//TODO: Add Checkmark for selected cells
	}
}

//MARK: - Fetch Results Controller Delegate
extension AddNewPlayerToLeagueVC: NSFetchedResultsControllerDelegate { }
