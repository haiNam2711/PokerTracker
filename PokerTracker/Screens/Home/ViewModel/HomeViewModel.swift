//
//  HomeViewModel.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import SQLite

class HomeViewModel {
    
    var games: [Game] = []
    
    var numberOfGames: Int {
        return games.count
    }
    
    func game(at index: Int) -> Game {
        return games[index]
    }
    
    func fetchGames() {
        do {
            if let fetchGames = try GameTable.findAll() {
                self.games = fetchGames
            } else {
                self.games = []
            }
        } catch {
            print("Error Fetch Games: \(error)")
        }
    }
    
    func createAGame(game: Game) throws -> Game? {
        return try GameTable.insert(item: game)
    }
    
    
    func showFilterScreen(from viewController: UIViewController) {
        let vc = FilterViewController()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCreateGameScreen(from viewController: UIViewController) {
        let vc = CreateaGameViewController()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showGameDetailsScreen(at index: Int, navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }
        let game = games[index]
        let gameVM = GameViewModel(gameID: game.id ?? 0, titleGame: "Poker: " + (game.time.toString()), cashin: game.standardCashIn, cashOut: game.standardChipOut, fee: game.fee, feeBool: game.feeTypeInValue)
        let gameDetailsVC = GameViewController()
        gameDetailsVC.viewModel = gameVM
        navigationController.pushViewController(gameDetailsVC, animated: true)
    }
    
    func sortGame() {
        games.sort { (game1, game2) in
            let time1 = game1.time.timeIntervalSince1970
            let time2 = game2.time.timeIntervalSince1970
            return time1 > time2
        }
    }
}

