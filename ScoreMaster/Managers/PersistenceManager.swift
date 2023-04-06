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
		static let leagues = "leagues"
	}
	
	
	//MARK: - Players using DataManager
	static func savePlayers() -> Error? {
		do {
			let encodedData = try JSONEncoder().encode(DataManager.shared.players)
			defaults.set(encodedData, forKey: Keys.players)
			return nil
		} catch {
			return error
		}
	}
	
	
	static func retrievePlayers() -> [Player] {
		guard let data = defaults.data(forKey: Keys.players) else {
			return []
		}
		
		do {
			let players = try JSONDecoder().decode([Player].self, from: data)
			return players
		} catch {
			print("ERROR decoding Players: \(error.localizedDescription)")
			return []
		}
	}
	
	
	//MARK: - League
	static func saveLeagues() -> Error? {
		do {
			let encodedData = try JSONEncoder().encode(DataManager.shared.leagues)
			defaults.set(encodedData, forKey: Keys.leagues)
			return nil
		} catch {
			return error
		}
	}
	
	
	static func retrieveLeagues() -> [League] {
		guard let data = defaults.data(forKey: Keys.leagues) else {
			return []
		}
		
		do {
			let players = try JSONDecoder().decode([League].self, from: data)
			return players
		} catch {
			print("ERROR decoding Leagues: \(error.localizedDescription)")
			return []
		}
	}
}
