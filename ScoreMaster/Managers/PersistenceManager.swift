//
//  PersistenceManager.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/5/23.
//

import Foundation

enum PersistenceManager {
	
	static private let defaults = UserDefaults.standard
	
	private enum Keys {
		static let players = "players"
	}
	
	
	static func save(players: [Player]) -> Error? {
		do {
			let encoder = JSONEncoder()
			let encodedPlayers = try encoder.encode(players)
			defaults.set(encodedPlayers, forKey: Keys.players)
			return nil
		} catch {
			return error
		}
	}
	
	
	static func retrievePlayers(completion: @escaping (Result<[Player], Error>) -> Void) {
		guard let data = defaults.data(forKey: Keys.players) else {
			completion(.success([]))
			return
		}
		do {
			let players = try JSONDecoder().decode([Player].self, from: data)
			completion(.success(players))
		} catch {
			completion(.failure(error))
		}
	}
}
