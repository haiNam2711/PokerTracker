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
    var playerActive: Bool
    var sumCashIn: Int
    var sumCashOut: Int
    var sumCashAfterFee: Int
    var sumChip: Int
    
    init(playerID: Int, gameID: Int, playerActive: Bool, sumCashIn: Int, sumCashOut: Int, sumChip: Int, sumCashAfterFee: Int) {
        self.playerID = playerID
        self.gameID = gameID
        self.playerActive = playerActive
        self.sumCashIn = sumCashIn
        self.sumCashOut = sumCashOut
        self.sumChip = sumChip
        self.sumCashAfterFee = sumCashAfterFee
    }
}
