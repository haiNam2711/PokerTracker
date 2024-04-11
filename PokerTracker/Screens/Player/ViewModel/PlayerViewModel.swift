//
//  PlayerViewModel.swift
//  PokerTracker
//
//  Created by VietChat on 11/4/24.
//

import Foundation

class PlayerViewModel {
    
    var player: GPlayerStatus?
    
    func fetchPlayerStatus(gameID: Int, playerID: Int) {
        do {
            guard let player = try GPlayerStatusTable.getPlayerStatus(gameID: gameID, playerID: playerID) else { return }
            self.player = player
        }catch {
            print(error.localizedDescription)
        }
    }
}
