//
//  PlayerModel.swift
//  PlayerGame
//
//  Created by Hai Nam on 8/4/24.
//

import Foundation

class GPlayerStatus {
    let playerID: Int
    let gameID: Int
    let playerActive: Bool
    let sumCashIn: Int
    let sumCashOut: Int
    
    init(playerID: Int, gameID: Int, playerActive: Bool, sumCashIn: Int, sumCashOut: Int) {
        self.playerID = playerID
        self.gameID = gameID
        self.playerActive = playerActive
        self.sumCashIn = sumCashIn
        self.sumCashOut = sumCashOut
    }
}
