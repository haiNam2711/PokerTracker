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
    let sumCashIn: Int
    let sumCashOut: Int
    
    init(playerID: Int, gameID: Int, sumCashIn: Int, sumCashOut: Int) {
        self.playerID = playerID
        self.gameID = gameID
        self.sumCashIn = sumCashIn
        self.sumCashOut = sumCashOut
    }
}
