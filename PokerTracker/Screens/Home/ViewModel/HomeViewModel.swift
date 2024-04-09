//
//  HomeViewModel.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import SQLite

final class HomeViewModel {
    
    var games: [Game] = [] {
        didSet {
            eventHandler?(.dataUpdate)
        }
    }
    var eventHandler: ((_ event: Event) -> Void)?
     
    func createAGame(game: Game) throws -> Game? {
        return try GameTable.insert(item: game)
    }
    
//    func getAllGames() throws {
//        guard let games = try GameTable.findAll() else {
//            throw NSError(domain: "HomeViewModel", code: 500, userInfo: [NSLocalizedDescriptionKey: "Faild to fetch games"])
//        }
//        self.games = games
//        eventHandler?(.dataLoader)
//    }
    
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

extension HomeViewModel {
    
    enum Event {
        case dataUpdate
    }
}
