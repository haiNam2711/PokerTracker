//
//  PlayerViewModel.swift
//  PokerTracker
//
//  Created by VietChat on 11/4/24.
//

import SQLite

class PlayerViewModel {
    
    var player: GPlayerStatus
    var gameRecord: GameRecord
    
    var name: String
    var gameID: Int
    var playerID: Int
    var amount = 0
    var cashIn: Int
    var cashOut: Int
    var sum = 0
    var amonutOld = 0
    
    var reloadDataHandler: ((String) -> Void)?
    
    init(name: String, gameID: Int, playerID: Int, cashIn: Int, cashOut: Int) {
        self.name = name
        self.gameID = gameID
        self.playerID = playerID
        self.cashIn = cashIn
        self.cashOut = cashOut
        self.player  = GPlayerStatus(playerID: 0, gameID: 0, playerActive: true, sumCashIn: 0, sumCashOut: 0, sumChip: 0, sumCashAfterFee: 0)
        self.gameRecord = GameRecord(gameID: 0, time: Date(), playerID: 0, cashIn: 0, cashOut: 0)
    }
    
    func fetchPlayerStatus() {
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
    
    func showRenameAlert(from viewController: UIViewController) {
        let alertController = UIAlertController(title: "Thay đổi tên", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = self.name
        }
        
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if let name = alertController.textFields?.first?.text {
                self?.updateName(playerID: self?.playerID ?? 0, name: name)
                self?.reloadDataHandler?(name)
                viewController.view.makeToast("Thay đổi tên thành công")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true)
    }
    
    func handleOKButton(from viewController: UIViewController, chipOutText: String?) {
        guard let chipOut = chipOutText, !chipOut.isEmpty else {
            sum = cashIn*amount
            if sum != 0 {
                cashInOrCashOut(gameRecord: GameRecord(gameID: gameID, time: Date(), playerID: playerID, cashIn: sum-player.sumCashIn, cashOut: 0))
                viewController.navigationController?.popViewController(animated: true)
            }
            return
        }
        guard let chipOut = Int(chipOut) else {
            return
        }
        let price = Int((Float(chipOut) / Float(cashOut))*Float(cashIn))
        sum = cashIn*amount
        cashInOrCashOut(gameRecord: GameRecord(gameID: gameID, time: Date(), playerID: playerID, cashIn: sum-player.sumCashIn, cashOut: price))
        viewController.navigationController?.popViewController(animated: true)
    }
    
    func backClick(from viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
}
