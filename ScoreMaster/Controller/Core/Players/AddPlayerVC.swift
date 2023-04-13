//
//  AddPlayerVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import UIKit
import CoreData


class AddPlayerVC: UIViewController {
	
	let nameTextField = SMTextField()
	let actionButton = SMButton(backgroundColor: .systemPink, title: "Add Player")
	
	var storageProvider: StorageProvider!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		layoutUI()
	}
	
	
	private func configureViewController() {
		view.backgroundColor = .systemBackground
		
		title = "Add Player"
		
		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
		navigationItem.rightBarButtonItem = cancelButton
		
		actionButton.addTarget(self, action: #selector(savePlayer), for: .touchUpInside)
	}
	
	@objc private func savePlayer() {
//		print(#function)
		
		let player = Player(context: storageProvider.context)
		player.name = nameTextField.text!
		
		dismiss(animated: true)
	}
	
	
	@objc private func dismissVC() {
		dismiss(animated: true)
	}
	
	
	private func layoutUI() {
		view.addSubview(nameTextField)
		view.addSubview(actionButton)
		
		NSLayoutConstraint.activate([
			nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			nameTextField.heightAnchor.constraint(equalToConstant: 40),
			
			actionButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
			actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			actionButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
}
