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
        viewModel.cashInOrCashOut(gameRecord: GameRecord(gameID: idGame, time: Date(), playerID: idPlayer, cashIn: amount, cashOut: 0))
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if amount < 1 {
            
        }else {
            amount -= 1
            cashInLabel.text = "\(amount)"
        }
        
    }
    
    @IBAction func moreAction(_ sender: Any) {
        amount += 1
        cashInLabel.text = "\(amount)"
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension PlayerViewController {
    
    func configuration() {
        nameLabel.text = name
        viewModel.fetchPlayerStatus(gameID: idGame, playerID: idPlayer)
        cashInLabel.text = "\(viewModel.player.sumCashIn)"
        amount = viewModel.player.sumCashIn
        print(viewModel.player.sumCashIn)
    }
}
