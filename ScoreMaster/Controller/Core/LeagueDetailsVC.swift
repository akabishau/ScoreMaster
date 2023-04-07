//
//  LeagueDetailsVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import UIKit

class LeagueDetailsVC: UIViewController {
	
	
	private var league: League
	
	private let tableView = UITableView()
	
	init(league: League) {
		self.league = league
		super.init(nibName: nil, bundle: nil)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		configureTableView()
		
	}
	
	
	private func configureViewController() {
		title = league.name
		view.backgroundColor = .systemBackground
		
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		navigationItem.rightBarButtonItem = addButton
	}
	
	
	@objc private func addButtonTapped() {
		print(#function)
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
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseId, for: indexPath) as! PlayerCell
		//cell.set(with: league.players[indexPath.row])
		return cell
	}
}

extension LeagueDetailsVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}


