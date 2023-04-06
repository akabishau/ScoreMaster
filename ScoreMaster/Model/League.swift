//
//  League.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import Foundation

struct League: Codable {
	let id: Int
	let name: String
	var players: [Player] = []
}
