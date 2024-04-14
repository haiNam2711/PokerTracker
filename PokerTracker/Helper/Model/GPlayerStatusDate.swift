//
//  GPlayerStatusDate.swift
//  PokerTracker
//
//  Created by Hai Nam on 14/4/24.
//

import Foundation
class GPlayerStatusDate: GPlayerStatus {
    let date: Date
    init(playerID: Int, gameID: Int, playerActive: Bool, sumCashIn: Int, sumCashOut: Int, sumChip: Int, sumCashAfterFee: Int, date: Date) {
        self.date = date
        super.init(playerID: playerID, gameID: gameID, playerActive: playerActive, sumCashIn: sumCashIn, sumCashOut: sumCashOut, sumChip: sumChip, sumCashAfterFee: sumCashAfterFee)
    }
}
