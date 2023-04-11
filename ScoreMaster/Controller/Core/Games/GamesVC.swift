//
//  GamesVC.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 3/30/23.
//

import UIKit

class GamesVC: UIViewController, UICollectionViewDataSource {
	
	private var games: [Game] = []
	private var collectionView: UICollectionView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		getGames()
		configureCollectionView()
	}
	
	
	private func getGames() {
		if let path = Bundle.main.path(forResource: "Games", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				games = try JSONDecoder().decode([Game].self, from: data)
				// update collection view
				DispatchQueue.main.async {
					
					self.collectionView.reloadData()
				}
			} catch {
				print("Error decoding local JSON file: \(error)")
			}
		} else {
			print("Local JSON file not found.")
		}
	}
	
	
	//MARK: - Collection View
	private func configureCollectionView() {
		let layout = createTwoColumnFlowLayout()
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
		view.addSubview(collectionView)
		collectionView.backgroundColor = .systemBackground
		collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseId)
		collectionView.dataSource = self
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return games.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseId, for: indexPath) as! GameCell
		cell.set(with: games[indexPath.item])
		return cell
	}
	
	
	private func createTwoColumnFlowLayout() -> UICollectionViewFlowLayout {
		
		let width = view.bounds.width
		let padding: CGFloat = 12
		let minItemSpacing: CGFloat = 5
		let availableWidth = width - padding * 2 - minItemSpacing * 2
		let itemWidth = availableWidth / 2
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 60)
		return flowLayout
	}
}
