//
//  AddLeagueVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/10/23.
//

import UIKit
import CoreData

class AddLeagueVC: UIViewController {
	
	var managedObjectContext: NSManagedObjectContext!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
	}
	
	private func configureViewController() {
		view.backgroundColor = .systemBackground
		title = "New League"
		
		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
		navigationItem.rightBarButtonItem = cancelButton
	}
	
	
	@objc private func saveLeague() {
		print(#function)
		
		let league = League(context: managedObjectContext)
		league.name = "46 Seconds"
		league.id = 1
		league.players = []
//		dismiss(animated: true)
	}
	
	
	@objc private func dismissVC() {
		saveLeague()
		dismiss(animated: true)
	}
}
