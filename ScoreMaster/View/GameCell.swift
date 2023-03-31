//
//  GameCell.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 3/31/23.
//

import UIKit

class GameCell: UICollectionViewCell {
	
	static let reuseId = String(describing: GameCell.self)
	
	private let coverImageView = UIImageView()
	private let nameLabel = UILabel()
	
	private let placeholderImage = UIImage(systemName: "checkerboard.shield")
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	
	override func prepareForReuse() {
		super.prepareForReuse()
		coverImageView.image = nil
		nameLabel.text = ""
	}
	
	
	func set(with game: Game) {
		coverImageView.image = placeholderImage
		nameLabel.text = game.name
	}
	
	
	private func configure() {
		layer.cornerRadius = 8
		layer.borderColor = UIColor.systemGray.cgColor
		layer.borderWidth = 1
		
		
		addSubview(coverImageView)
		addSubview(nameLabel)
		
		coverImageView.translatesAutoresizingMaskIntoConstraints = false
		coverImageView.contentMode = .scaleAspectFit
		coverImageView.clipsToBounds = true
		coverImageView.tintColor = .systemPink
		
		
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.textAlignment = .center
		nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		nameLabel.numberOfLines = 2
		
		let padding: CGFloat = 8
		
		NSLayoutConstraint.activate([
			coverImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
			coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor),
			
			nameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 12),
			nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
		])
	}
}
