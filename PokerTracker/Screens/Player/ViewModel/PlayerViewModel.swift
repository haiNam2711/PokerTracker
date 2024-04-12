//
//  PlayerViewModel.swift
//  PokerTracker
//
//  Created by VietChat on 11/4/24.
//

import Foundation

class PlayerViewModel {
    
    var player: GPlayerStatus = GPlayerStatus(playerID: 0, gameID: 0, playerActive: true, sumCashIn: 0, sumCashOut: 0, sumChip: 0, sumCashAfterFee: 0)
    
    var gameRecord: GameRecord = GameRecord(gameID: 0, time: Date(), playerID: 0, cashIn: 0, cashOut: 0)
    
    func fetchPlayerStatus(gameID: Int, playerID: Int) {
        do {
            guard let player = try GPlayerStatusTable.getPlayerStatus(gameID: gameID, playerID: playerID) else { return }
            self.player = player
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func cashInOrCashOut(gameRecord: GameRecord) {
        do {
            try GameRecordTable.insert(item: gameRecord)
            try GPlayerStatusTable.update(withNewMoneyRecord: gameRecord)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateName(playerID: Int, name: String) {
        do {
            try PlayerTable.updateName(idPlayer: playerID, newName: name)
        }catch {
            print(error.localizedDescription)
        }
    }
    
//    func addPlayerToGame(playerID: Int, gameID: Int, sumCashin: Int, sumCashOut: Int, active: Bool) {
//        do {
//            try GPlayerStatusTable.insert(item: GPlayerStatus(playerID: playerID, gameID: gameID, playerActive: active, sumCashIn: sumCashin, sumCashOut: sumCashOut, sumChip: 0, sumCashAfterFee: 0))
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
//    func updatePlayer(idGame: Int, idPlayer: Int, cashIn: Int, cashOut: Int, cashFee: Int, chipOut: Int, active: Bool) {
//        do {
//            let player = try GPlayerStatusTable.updatePlayer(idGame: idGame, idPlayer: idPlayer, cashIn: cashIn, cashOut: cashOut, cashFee: cashFee, chipOut: chipOut, active: active)
//        }catch {
//            print(error.localizedDescription)
//        }
//    }
}
