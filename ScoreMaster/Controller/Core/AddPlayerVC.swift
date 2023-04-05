//
//  AddPlayerVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import UIKit

protocol AddPlayerVCDelegate: AnyObject {
	func didAddPlayer(_ player: Player)
}


class AddPlayerVC: UIViewController {
	
	let nameTextField = SMTextField()
	let actionButton = SMButton(backgroundColor: .systemPink, title: "Add Player")
	
	
	weak var delegate: AddPlayerVCDelegate?
	
	
	
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
		
		actionButton.addTarget(self, action: #selector(addPlayerAndDismiss), for: .touchUpInside)
	}
	
	
	@objc private func addPlayerAndDismiss() {
		delegate?.didAddPlayer(Player(name: nameTextField.text!, avatar: "", email: ""))
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
