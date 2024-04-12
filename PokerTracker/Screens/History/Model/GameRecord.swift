//
//  GameRecord.swift
//  PlayerGame
//
//  Created by Hai Nam on 8/4/24.
//

import Foundation

class GameRecord {
    let id: Int?
    let gameID: Int
    let time: Date
    let playerID: Int
    var cashIn: Int
    var cashOut: Int
    
    init(id: Int? = nil, gameID: Int, time: Date, playerID: Int, cashIn: Int, cashOut: Int) {
        self.id = id
        self.gameID = gameID
        self.time = time
        self.playerID = playerID
        self.cashIn = cashIn
        self.cashOut = cashOut
    }
}
