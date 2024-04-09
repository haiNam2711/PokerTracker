//
//  GeneralService.swift
//  PokerTracker
//
//  Created by Hai Nam on 9/4/24.
//

import Foundation
class GeneralService {
}

//MARK: - Home Screen
extension GeneralService {
 
    static func createAGame(game: Game) throws -> Game? {
        return try GameTable.insert(item: game)
    }
    
    static func getAllGames() throws -> [Game]? {
        return try GameTable.findAll()
    }
    
}

//MARK: - Game Screen
extension GeneralService {
    
    static func getAllPlayers() throws -> [Player]? {
        return try PlayerTable.findAll()
    }
    
    static func createNewPlayer(player: Player) throws {
        try PlayerTable.insert(item: player)
    }
    
    static func addPlayerToAGame(playerID: Int, gameID: Int) throws {
        try GPlayerStatusTable.insert(item: GPlayerStatus(playerID: playerID, gameID: gameID, sumCashIn: 0, sumCashOut: 0))
    }
    
}

//MARK: - Player Screen
extension GeneralService {
    
}

//MARK: - History Screen
extension GeneralService {
    
}
