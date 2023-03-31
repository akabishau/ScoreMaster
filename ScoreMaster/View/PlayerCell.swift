//
//  PlayerCell.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 3/30/23.
//

import UIKit

class PlayerCell: UITableViewCell {
	
	static let reuseId = String(describing: PlayerCell.self)
	
	private let nameLabel = UILabel()
	private let avatarImageView = UIImageView()
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	
	override func prepareForReuse() {
		super.prepareForReuse()
		avatarImageView.image = nil
	}
	
	
	func set(with player: Player) {
		nameLabel.text = player.name
		avatarImageView.image = UIImage(systemName: "person.and.background.dotted")
	}
	
	
	private func configure() {
		addSubview(avatarImageView)
		addSubview(nameLabel)
		
		avatarImageView.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		
		avatarImageView.contentMode = .scaleAspectFit
		avatarImageView.tintColor = .systemPink
		
		let padding: CGFloat = 12
		
		NSLayoutConstraint.activate([
			avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			avatarImageView.widthAnchor.constraint(equalToConstant: 60),
			avatarImageView.heightAnchor.constraint(equalToConstant: 60),
			
			nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding * 2),
			nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			nameLabel.heightAnchor.constraint(equalToConstant: 40 )
		])
	}
}


