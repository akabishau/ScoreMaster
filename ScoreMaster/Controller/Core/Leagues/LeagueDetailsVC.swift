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
	private var storageProvider: StorageProvider
	
	init(league: League, storageProvider: StorageProvider) {
		self.league = league
		self.storageProvider = storageProvider
		
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
		return fetchedResultsController
	}()
	
	
	private lazy var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> = {
		print("players data source creation")
		let dataSource = UITableViewDiffableDataSource<String, NSManagedObjectID>(tableView: tableView) { tableView, indexPath, itemIdentifier in
			
			guard let player = try? self.storageProvider.context.existingObject(with: itemIdentifier) as? Player else { return nil }
			let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseId, for: indexPath) as! PlayerCell
			cell.set(with: player)
			return cell
		}
		return dataSource
	}()

	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureTableView()
		configureViewController()
		fetchPlayers()
	}
	
	private func fetchPlayers() {
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("Unable to Perform Fetch Request")
			print("\(error), \(error.localizedDescription)")
		}
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
		
		tableView.dataSource = dataSource
		tableView.delegate = self
		
		tableView.register(PlayerCell.self, forCellReuseIdentifier: PlayerCell.reuseId)
	}
}


extension LeagueDetailsVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}


extension LeagueDetailsVC: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		
		print(#function, #file)
		let leaguesSnapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
		dataSource.apply(leaguesSnapshot)
	}
}
