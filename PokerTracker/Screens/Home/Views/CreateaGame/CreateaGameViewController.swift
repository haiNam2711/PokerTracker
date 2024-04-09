//
//  CreateaGameViewController.swift
//  PokerTracker
//
//  Created by VietChat on 9/4/24.
//

import UIKit

class CreateaGameViewController: UIViewController {

    @IBOutlet weak var cashInTF: UITextField!
    @IBOutlet weak var cashOutTF: UITextField!
    @IBOutlet weak var feeTF: UITextField!
    
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func startGameOnClick(_ sender: Any) {
        guard let cashIn = cashInTF.text, let cashOut = cashOutTF.text, let fee = feeTF.text else { return }
        let newGame = Game(time: Date(), standardCashIn: Int(cashIn) ?? 0, standardChipOut: Int(cashOut) ?? 0, feeTypeInValue: true, fee: Int(fee) ?? 0)
        do {
            if let createGame = try viewModel.createAGame(game: newGame) {
                print("Thanh cong")
            }else {
                print("That bai")
            }
        } catch {
            print("Loi")
        }
    }
    

}
