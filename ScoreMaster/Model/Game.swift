//
//  Game.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 3/31/23.
//

import Foundation

struct Game: Codable {
	let name: String
	let description: String
	let minPlayers: Int
	let maxPlayers: Int
	let recommendedPlayers: Int
	let playtime: Int
	let ageRating: String
	let publisher: String
	let designer: String
	let yearPublished: Int
	let coverUrl: String
}


