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
	
	let nameTextField = SMTextField()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		layoutUI()
	}
	
	private func configureViewController() {
		view.backgroundColor = .systemBackground
		title = "Add New League"
		
		let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveLeague))
		navigationItem.rightBarButtonItem = saveButton
		
		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
		navigationItem.leftBarButtonItem = cancelButton
	}
	
	
	@objc private func saveLeague() {
		print(#function)
		
		let league = League(context: managedObjectContext)
		league.name = nameTextField.text
		league.id = 1
		league.players = []
		dismiss(animated: true)
	}
	
	
	@objc private func dismissVC() {
		dismiss(animated: true)
	}
	
	
	private func layoutUI() {
		
		view.addSubview(nameTextField)
		nameTextField.placeholder = "Enter Your League Name"
		
		let padding: CGFloat = 20
		
		NSLayoutConstraint.activate([
			nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
			nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
			nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
			nameTextField.heightAnchor.constraint(equalToConstant: 40)
		
		])
	}
}
