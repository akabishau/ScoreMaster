//
//  LeaguesVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import UIKit

class LeaguesVC: UIViewController {
	
	private let tableView = UITableView()
	private var leagues: [League] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureTableView()
	}
	
	
	
	private func configureTableView() {
		view.addSubview(tableView)
		tableView.frame = view.bounds
		tableView.rowHeight = 80
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyle")
	}
}



extension LeaguesVC: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return leagues.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
		cell.textLabel?.text = leagues[indexPath.row].name
		return cell
	}
}

extension LeaguesVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let detailsVC = LeagueDetailsVC(league: leagues[indexPath.row])
		navigationController?.pushViewController(detailsVC, animated: true)
	}
}
