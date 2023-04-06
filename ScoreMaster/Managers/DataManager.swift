//
//  DataManager.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import Foundation

class DataManager {
	
	static let shared = DataManager()
	
	var players: [Player]
	var leagues: [League]
	
	private init() {
		players = PersistenceManager.retrievePlayers()
		leagues = PersistenceManager.retrieveLeagues()
	}
}
