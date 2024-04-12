//
//  GameViewModel.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import Foundation

final class GameViewModel {
    
    var players: [Player] = []
    var success = false
    
    var player: GPlayerStatus = GPlayerStatus(playerID: 0, gameID: 0, playerActive: true, sumCashIn: 0, sumCashOut: 0, sumChip: 0, sumCashAfterFee: 0)
    
    func createNewPlayer(player: Player) {
        do {
            if players.contains(where: { $0.name == player.name }) {
                success = false
            }else {
                var newPlayer = try PlayerTable.insert(item: player)
                players.append(newPlayer)
                success = true
            }
        }catch {
            success = false
        }
    }
    
    func fetchPlayer() {
        do {
            guard let allPlayer = try PlayerTable.findAll() else {
                return
            }
            self.players = allPlayer
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addPlayerToGame(playerID: Int, gameID: Int) {
        do {
            try GPlayerStatusTable.insert(item: GPlayerStatus(playerID: playerID, gameID: gameID, playerActive: false, sumCashIn: 0, sumCashOut: 0, sumChip: 0, sumCashAfterFee: 0))
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchPlayerStatus(gameID: Int, playerID: Int) -> GPlayerStatus? {
        do {
            guard let player = try GPlayerStatusTable.getPlayerStatus(gameID: gameID, playerID: playerID) else { return nil }
            return player
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}

