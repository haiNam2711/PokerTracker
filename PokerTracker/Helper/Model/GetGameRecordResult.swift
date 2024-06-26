//
//  GetGameRecordResult.swift
//  PokerTracker
//
//  Created by Hai Nam on 11/4/24.
//

import Foundation
class GetGameRecordResult: GameRecord {
    var playerName: String
    init(id: Int, playerName: String, gameID: Int, time: Date, playerID: Int, cashIn: Int, cashOut: Int) {
        self.playerName = playerName
        super.init(id: id, gameID: gameID, time: time, playerID: playerID, cashIn: cashIn, cashOut: cashOut)
    }
}
