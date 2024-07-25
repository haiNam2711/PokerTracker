//
//  CreateGameViewModel.swift
//  PokerTracker
//
//  Created by VietChat on 15/4/24.
//

import SQLite

class CreateGameViewModel {
    
    var cashIn: String?
    var cashOut: String?
    var fee: String?
    var feeType: Bool = true
    
    func backClick(from viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
    
    func createGame(from viewController: UIViewController, cashIn: String?, cashOut: String?, fee: String?, feeType: Bool = true) {
        guard let cashIn = cashIn, !cashIn.isEmpty,
              let cashOut = cashOut, !cashOut.isEmpty,
              let fee = fee, !fee.isEmpty, cashOut != "0", cashIn != "0" else {
            return
        }
        
        let newGame = Game(time: Date(),
                           standardCashIn: Int(cashIn) ?? 0,
                           standardChipOut: Int(cashOut) ?? 0,
                           feeTypeInValue: feeType,
                           fee: Int(fee) ?? 0)
        
        do {
            if let createdGame = try GameTable.insert(item: newGame) {
                let gameID = createdGame.id ?? 0
                let gameVM = GameViewModel(gameID: gameID,titleGame: "Poker: " + (Date().toDateTimeString()), cashin: Int(cashIn) ?? 0, cashOut: Int(cashOut) ?? 0, fee: Int(fee) ?? 0, feeBool: feeType)
                let vc = GameViewController()
                viewController.navigationController?.pushViewController(vc, animated: true)
                vc.viewModel = gameVM
                print("Tạo phòng thành công")
            } else {
                print("Tạo phòng thất bại")
            }
        } catch {
            print("Lỗi tạo phòng")
        }
        UserDefaults.standard.set(cashIn, forKey: "cashin")
        UserDefaults.standard.set(cashOut, forKey: "cashout")
        UserDefaults.standard.set(fee, forKey: "fee")
        UserDefaults.standard.set(feeType, forKey: "feetype")
    }
    
    func loadUserDefaults() {
        cashIn = UserDefaults.standard.string(forKey: "cashin")
        cashOut = UserDefaults.standard.string(forKey: "cashout")
        fee = UserDefaults.standard.string(forKey: "fee")
        feeType = UserDefaults.standard.bool(forKey: "feetype")
    }
}
