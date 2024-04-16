//
//  GameViewModel.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import SQLite

final class GameViewModel {
    
    var players: [Player] = []
    var player: GPlayerStatus
    
    var titleGame: String = ""
    var cashin: Int = 0
    var cashOut: Int = 0
    var fee: Int = 0
    var feeBool = true
    var playerID = 0
    var gameID: Int = 0
    var success = false
    
    var isNameNew = false
    var okAction: UIAlertAction!
    var reloadDataHandler: (() -> Void)?
    
    init(gameID: Int, titleGame: String, cashin: Int, cashOut: Int, fee: Int, feeBool: Bool) {
        self.gameID = gameID
        self.titleGame = titleGame
        self.cashin = cashin
        self.cashOut = cashOut
        self.fee = fee
        self.feeBool = feeBool
        self.player = GPlayerStatus(playerID: 0, gameID: 0, playerActive: true, sumCashIn: 0, sumCashOut: 0, sumChip: 0, sumCashAfterFee: 0)
    }
    
    var numberOfPlayers: Int {
        return players.count
    }
    
    func player(at index: Int) -> Player {
        return players[index]
    }
    
    func createNewPlayer(player: Player) {
        do {
            if players.contains(where: { $0.name == player.name }) {
                success = false
            }else {
                let newPlayer = try PlayerTable.insert(item: player)
                players.append(newPlayer)
                success = true
            }
        }catch {
            success = false
        }
    }
    
    func goBackToHome(from viewController: UIViewController) {
        if let homeVC = viewController.navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
            viewController.navigationController?.popToViewController(homeVC, animated: true)
        }
    }
    
    func showHistoryScreen(from viewController: UIViewController) {
        let historyVC = HistoryViewController()
        historyVC.gameID = gameID
        viewController.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func showPlayerDetailsScreen(at index: Int, navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }
        let player = players[index]
        let playerVM = PlayerViewModel(name: player.name, gameID: gameID, playerID: player.id ?? 0, cashIn: Int(cashin), cashOut: cashOut)
        let playerDetailsVC = PlayerViewController()
        playerDetailsVC.viewModel = playerVM
        navigationController.pushViewController(playerDetailsVC, animated: true)
    }
    
    func showNameAlert(from viewController: UIViewController) {
        let alertController = UIAlertController(title: "Thêm người chơi mới", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Tên của bạn"
            textField.autocapitalizationType = .sentences
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if self?.isNameNew == true {
                if let name = alertController.textFields?.first?.text, !name.isEmpty {
                    let player = Player(name: name)
                    self?.createNewPlayer(player: player)
                    if self?.success == true {
                        viewController.view.makeToast("Thêm người chơi thành công")
                        self?.reloadDataHandler?()
                    }else {
                        viewController.view.makeToast("Người chơi đã tồn tại hoặc có lỗi đã xảy ra")
                    }
                }
            }else {
                viewController.view.makeToast("Bạn chưa nhập tên")
            }
        }
        okAction.isEnabled = false
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            isNameNew = true
        } else {
            isNameNew = false
        }
        okAction.isEnabled = isNameNew
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
            return try GPlayerStatusTable.getPlayerStatus(gameID: gameID, playerID: playerID)
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func sortPlayersByCashIn(gameID: Int) {
        players.sort { (player1, player2) -> Bool in
            guard let status1 = fetchPlayerStatus(gameID: gameID, playerID: player1.id ?? 0),
                  let status2 = fetchPlayerStatus(gameID: gameID, playerID: player2.id ?? 0) else {
                if fetchPlayerStatus(gameID: gameID, playerID: player1.id ?? 0) == nil {
                    return false
                } else {
                    return true
                }
            }
            let cashIn1 = status1.sumCashIn
            let cashIn2 = status2.sumCashIn
            return cashIn1 > cashIn2
        }
    }
}
