//
//  GameModel.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import Foundation

class Game {
    let id: Int?
    let time: Date
    let standardCashIn: Int
    let standardChipOut: Int
    let fee: Int

    init(id: Int? = nil, time: Date, standardCashIn: Int, standardChipOut: Int, fee: Int) {
        self.id = id
        self.time = time
        self.standardCashIn = standardCashIn
        self.standardChipOut = standardChipOut
        self.fee = fee
    }
}
