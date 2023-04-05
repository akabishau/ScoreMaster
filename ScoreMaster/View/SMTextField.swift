//
//  SMTextField.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import UIKit

class SMTextField: UITextField {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	
	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		
		layer.borderWidth = 2
		layer.cornerRadius = 10
		layer.borderColor = UIColor.systemGray4.cgColor
		
		textColor = .label
		tintColor = .label // blinking cursor in this case
		textAlignment = .center
		font = UIFont.preferredFont(forTextStyle: .title2)
		adjustsFontSizeToFitWidth = true // makes font smaller when input is too long
		minimumFontSize = 12
		
		backgroundColor = .tertiarySystemBackground
		autocorrectionType = .no
		keyboardType = .default
		returnKeyType = .go
		placeholder = "Enter a username"
		//		clearButtonMode = .whileEditing
	}
}
