//
//  GameRecord.swift
//  PlayerGame
//
//  Created by Hai Nam on 8/4/24.
//

import Foundation

class GameRecord {
    let gameID: Int
    let time: Date
    let playerID: Int
    let cashIn: Int
    let cashOut: Int
    
    init(gameID: Int, time: Date, playerID: Int, cashIn: Int, cashOut: Int) {
        self.gameID = gameID
        self.time = time
        self.playerID = playerID
        self.cashIn = cashIn
        self.cashOut = cashOut
    }
}
