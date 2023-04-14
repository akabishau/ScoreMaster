//
//  LeaguesVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import UIKit
import CoreData

class LeaguesVC: UIViewController {
	
	private var tableView =  UITableView()
	
	var storageProvider: StorageProvider!
	
	private lazy var fetchedResultsController: NSFetchedResultsController<League> = {
		
		let fetchRequest: NSFetchRequest<League> = League.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: storageProvider.context, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()
	
	
	private lazy var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> = {
		print("leagues data source creation")
		let dataSource = UITableViewDiffableDataSource<String, NSManagedObjectID>(tableView: tableView) { tableView, indexPath, itemIdentifier in
			
			guard let league = try? self.storageProvider.context.existingObject(with: itemIdentifier) as? League else { return nil }
			let cell = UITableViewCell(style: .default, reuseIdentifier: "basicStyle")
			cell.textLabel?.text = league.name
			return cell
		}
		return dataSource
	}()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureViewController()
		configureTableView()
		fetchLeagues()
	}
	
	
	private func fetchLeagues() {
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("Unable to Perform Fetch Request")
			print("\(error), \(error.localizedDescription)")
		}
	}
	
	
	@objc private func addButtonTapped() {
		let addLeagueVC = AddLeagueVC()
		addLeagueVC.storageProvider = storageProvider
		//TODO: is this a valid scenario? Change to push/pop
		let navigationController = UINavigationController(rootViewController: addLeagueVC)
		present(navigationController, animated: true)
	}
	
	
	
	private func configureTableView() {
		tableView.frame = view.bounds
		tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		tableView.rowHeight = 80
		view.addSubview(tableView)
		
		tableView.dataSource = dataSource
		tableView.delegate = self
	}
	
	
	private func configureViewController() {
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		navigationItem.rightBarButtonItem = addButton
	}
}


extension LeaguesVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let league = fetchedResultsController.object(at: indexPath)
		let detailsVC = LeagueDetailsVC(league: league, storageProvider: storageProvider)
		navigationController?.pushViewController(detailsVC, animated: true)
	}
}


//MARK: - Fetch Results Controller Delegate
extension LeaguesVC: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		
		print(#function, #file)
		let leaguesSnapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
		dataSource.apply(leaguesSnapshot)
	}
}
