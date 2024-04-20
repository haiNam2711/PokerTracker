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
    
    var isNameNew = false
    var okAction: UIAlertAction!
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
    
    func updateName(playerID: Int, name: String) -> Bool {
        do {
            let checkNameNew = try PlayerTable.getPlayerByName(name)
            guard checkNameNew == nil || checkNameNew?.id == playerID else {
                return false
            }
            try PlayerTable.updateName(idPlayer: playerID, newName: name)
            return true
        }catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func showRenameAlert(from viewController: UIViewController) {
        let alertController = UIAlertController(title: "Thay đổi tên", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = self.name
            textField.autocapitalizationType = .sentences
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if self?.isNameNew == true {
                if let name = alertController.textFields?.first?.text, !name.isEmpty {
                    if self?.updateName(playerID: self?.playerID ?? 0, name: name) == true {
                        self?.reloadDataHandler?(name)
                        viewController.view.makeToast("Thay đổi tên thành công")
                    }else {
                        viewController.view.makeToast("Tên người chơi đã tồn tại hoặc có lỗi xảy ra")
                    }
                }
            } else {
                viewController.view.makeToast("Bạn chưa nhập tên")
            }
        }
        okAction.isEnabled = false
        //        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        //        let attributedText = NSMutableAttributedString(string: "OK", attributes: [NSAttributedString.Key.font: boldFont])
        //        okAction.setValue(attributedText, forKey: "attributedTitle")
        //        let font = UIFont.systemFont(ofSize: 16)
        //        let attributed = NSMutableAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.font: font])
        //        cancelAction.setValue(attributed, forKey: "attributedTitle")
        cancelAction.setValue(UIColor.hexStringToUIColor(hex: "#EB442C"), forKey: "titleTextColor")
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
    
    func handleOKButton(from viewController: UIViewController, chipOutText: String?) {
        guard let chipOut = chipOutText, !chipOut.isEmpty else {
            if amount < amonutOld {
                showAlertCheck(from: viewController) { [weak self] successPicked in
                    if successPicked {
                        let amonutD = (self?.amonutOld ?? 0) - (self?.amount ?? 0)
                        let tmpGameRecord = GameRecord(gameID: self?.gameID ?? 0, time: Date(), playerID: self?.playerID ?? 0, cashIn: amonutD*(self?.cashIn ?? 0), cashOut: 0)
                        self?.deleteRecord(gameRecord: tmpGameRecord)
                        viewController.navigationController?.popViewController(animated: true)
                    }else {
                        
                    }
                }
            }else {
                sum = cashIn*amount
                if sum != 0 {
                    cashInOrCashOut(gameRecord: GameRecord(gameID: gameID, time: Date(), playerID: playerID, cashIn: sum-player.sumCashIn, cashOut: 0))
                    viewController.navigationController?.popViewController(animated: true)
                }
            }
            return
        }
        guard let chipOut = Int(chipOut) else {
            return
        }
        let chipOutF = Double(chipOut)
        let cashOutF = Double(cashOut)
        let cashInF = Double(cashIn)
        var cashOutK: Double = 0
        var price: Double = 0
        let cashOutOld = Double((Float(player.sumCashOut)/Float(cashIn))*Float(cashOut))
        if cashOutOld != chipOutF && cashOutOld != 0.0 {
            showAlertCheck(from: viewController) { [weak self] succes in
                guard let self else { return }
                if succes {
                    cashOutK = chipOutF/cashOutF
                    price = cashOutK*cashInF
                    self.sum = (self.cashIn)*(self.amount)
                    do {
                        try GameRecordTable.deleteCashOutRecord(byGameId: self.player.gameID, playerId: self.playerID)
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.cashInOrCashOut(gameRecord: GameRecord(gameID: self.gameID, time: Date(), playerID: self.playerID, cashIn: (self.sum)-(self.player.sumCashIn), cashOut: Int(price)))
                    viewController.navigationController?.popViewController(animated: true)
                }else {
                    
                }
            }
            //            }
        }else {
            if amount == amonutOld {
                cashOutK = chipOutF/cashOutF
                price = cashOutK*cashInF
                sum = cashIn*amount
                cashInOrCashOut(gameRecord: GameRecord(gameID: gameID, time: Date(), playerID: playerID, cashIn: sum-player.sumCashIn, cashOut: Int(price)))
                viewController.navigationController?.popViewController(animated: true)
            }else {
                showAlertCheck(from: viewController) { [weak self] succes in
                    guard let self else { return }
                    if succes {
                        if amount > amonutOld {
                            cashOutK = chipOutF/cashOutF
                            price = cashOutK*cashInF
                            let amonutD = (self.amount) - (self.amonutOld)
                            let tmpGameRecord = GameRecord(gameID: self.gameID, time: Date(), playerID: self.playerID, cashIn: amonutD*(self.cashIn), cashOut: Int(price))
                            self.updateRecord(gameRecord: tmpGameRecord)
                            viewController.navigationController?.popViewController(animated: true)
                        }else {
                            cashOutK = chipOutF/cashOutF
                            price = cashOutK*cashInF
                            let amonutD = (self.amonutOld) - (self.amount)
                            let tmpGameRecord = GameRecord(gameID: self.gameID, time: Date(), playerID: self.playerID, cashIn: amonutD*(self.cashIn), cashOut: Int(price))
                            self.deleteRecord(gameRecord: tmpGameRecord)
                            viewController.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                    else {
                        
                    }
                }
            }
        }
    }
    
    func showAlertCheck(from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Xác nhận thay đổi", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel) { _ in
            completion(false)
        }
        okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion(true)
        }
        cancelAction.setValue(UIColor.hexStringToUIColor(hex: "#EB442C"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true)
    }
    
    func deleteRecord(gameRecord: GameRecord) {
        do {
            try GPlayerStatusTable.deleteARecord(gameRecord: gameRecord)
            try GameRecordTable.insert(item: GameRecord(gameID: gameRecord.gameID, time: gameRecord.time, playerID: gameRecord.playerID, cashIn: gameRecord.cashIn, cashOut: gameRecord.cashOut))
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func updateRecord(gameRecord: GameRecord) {
        do {
            try GPlayerStatusTable.update(withNewMoneyRecord: gameRecord)
            try GameRecordTable.insert(item: GameRecord(gameID: gameRecord.gameID, time: gameRecord.time, playerID: gameRecord.playerID, cashIn: -gameRecord.cashIn, cashOut: gameRecord.cashOut))
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func backClick(from viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
}
