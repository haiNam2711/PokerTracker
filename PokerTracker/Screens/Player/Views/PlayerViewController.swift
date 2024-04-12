//
//  PlayerViewController.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import UIKit

class PlayerViewController: UIViewController {

    var name: String = ""
    var idGame = 0
    var idPlayer = 0
    var amount = 0
    var cashIn = 0
    var sum = 0
    var newAmonut = 0
    
    private let viewModel = PlayerViewModel()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cashInLabel: UILabel!
    @IBOutlet weak var cashOutLabel: UITextField!
    @IBOutlet weak var deleteBT: UIButton!
    @IBOutlet weak var moreBT: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
    }

    @IBAction func okOnclick(_ sender: Any) {
        sum = cashIn * amount
        viewModel.cashInOrCashOut(gameRecord: GameRecord(gameID: idGame, time: Date(), playerID: idPlayer, cashIn: sum, cashOut: 0))
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if amount < viewModel.player.sumCashIn {
            
        }else {
            amount -= 1
            cashInLabel.text = "\(amount)"
        }
        
    }
    
    @IBAction func moreAction(_ sender: Any) {
        amount += 1
        newAmonut = amount
        cashInLabel.text = "\(newAmonut)"
        print(newAmonut)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func updateNameAction(_ sender: Any) {
        renamePlayer()
    }
}

extension PlayerViewController {
    
    func configuration() {
        nameLabel.text = name
        viewModel.fetchPlayerStatus(gameID: idGame, playerID: idPlayer)
        amount = viewModel.player.sumCashIn / cashIn
        cashInLabel.text = "\(amount - newAmonut)"
    }
    
    func renamePlayer() {
        let alertController = UIAlertController(title: "Thay đổi tên", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = self.name
        }
        
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if let name = alertController.textFields?.first?.text {
                print("id: \(self?.idPlayer)")
                self?.viewModel.updateName(playerID: self?.idPlayer ?? 0, name: name)
//                if self?.viewModel.success == true {
                self?.nameLabel.text = name
                    self?.view.makeToast("Thay đổi tên thành công")
//                }else {
//                    self?.view.makeToast("Người chơi đã tồn tại hoặc có lỗi đã xảy ra")
//                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)

    }
}
