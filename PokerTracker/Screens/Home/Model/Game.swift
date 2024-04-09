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
    let feeTypeInValue: Bool
    let fee: Int

    init(id: Int? = nil, time: Date, standardCashIn: Int, standardChipOut: Int, feeTypeInValue: Bool, fee: Int) {
        self.id = id
        self.time = time
        self.standardCashIn = standardCashIn
        self.standardChipOut = standardChipOut
        self.feeTypeInValue = feeTypeInValue
        self.fee = fee
    }
}
