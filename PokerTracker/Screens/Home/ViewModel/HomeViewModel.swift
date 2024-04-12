//
//  HomeViewModel.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import SQLite

final class HomeViewModel {
    
    var games: [Game] = []
     
    func createAGame(game: Game) throws -> Game? {
        return try GameTable.insert(item: game)
    }
    
    func fetchGames() {
        do {
            if let fetchGames = try GameTable.findAll() {
                self.games = fetchGames
            }else {
                self.games = []
            }
        } catch {
            self.games = []
            print("Error Fetch Games: \(error)")
        }
    }
}
