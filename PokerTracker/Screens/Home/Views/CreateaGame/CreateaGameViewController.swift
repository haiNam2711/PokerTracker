//
//  CreateaGameViewController.swift
//  PokerTracker
//
//  Created by VietChat on 9/4/24.
//

import UIKit
import Toast
import MBRadioButton

class CreateaGameViewController: UIViewController {

    @IBOutlet weak var cashInTF: UITextField!
    @IBOutlet weak var cashOutTF: UITextField!
    @IBOutlet weak var feeTF: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var viewGroup: UIView!
    @IBOutlet weak var ptBT: RadioButton!
    @IBOutlet weak var kBT: RadioButton!
    @IBOutlet weak var feeLabel: UILabel!
    
    private var viewModel = HomeViewModel()
    var groupContainer = RadioButtonContainer()
    var selectFee = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    @IBAction func startGameOnClick(_ sender: Any) {
        guard let cashIn = cashInTF.text, let cashOut = cashOutTF.text, let fee = feeTF.text else { return }
        let newGame = Game(time: Date(), standardCashIn: Int(cashIn) ?? 0, standardChipOut: Int(cashOut) ?? 0, feeTypeInValue: selectFee, fee: Int(fee) ?? 0)
        UserDefaults.standard.setValue(cashIn, forKey: "cashin")
        UserDefaults.standard.setValue(cashOut, forKey: "cashout")
        UserDefaults.standard.setValue(fee, forKey: "fee")
        do {
            if let createGame = try viewModel.createAGame(game: newGame) {
                self.view.makeToast("Tạo phòng thành công")
                let vc = GameViewController()
                vc.titleGame = "Poker: " + Date().toString()
                vc.cashin = cashIn + "k"
                vc.cashOut = cashOut + " chip"
                vc.fee = fee + (feeLabel.text ?? "")
                navigationController?.pushViewController(vc, animated: true)
            }else {
                self.view.makeToast("Tạo phòng thất bại")
            }
        } catch {
            self.view.makeToast("Lỗi tạo phòng")
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension CreateaGameViewController {
    
    func configuration() {
        cashInTF.layer.borderColor = UIColor.borderColorTF()
        cashOutTF.layer.borderColor = UIColor.borderColorTF()
        feeTF.layer.borderColor = UIColor.borderColorTF()
        startButton.backgroundColor = UIColor.backAlphaColorBT()
        cashInTF.text = UserDefaults.standard.string(forKey: "cashin")
        cashOutTF.text = UserDefaults.standard.string(forKey: "cashout")
        feeTF.text = UserDefaults.standard.string(forKey: "fee")
        cashInTF.layer.borderColor = UIColor.colorTF()
        cashOutTF.layer.borderColor = UIColor.colorTF()
        feeTF.layer.borderColor = UIColor.colorTF()
        cashInTF.becomeFirstResponder()
        cashInTF.delegate = self
        cashOutTF.delegate = self
        feeTF.delegate = self
        groupContainer.addButtons([ptBT, kBT])
        groupContainer.delegate = self
        if UserDefaults.standard.bool(forKey: "feetype") {
            groupContainer.selectedButton = ptBT
            feeLabel.text = "%"
        }else {
            groupContainer.selectedButton = kBT
            feeLabel.text = "K"
        }
    }
}

extension CreateaGameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor =  UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 1.00).cgColor
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let cashIn = (cashInTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let cashOut = (cashOutTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let fee = (feeTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        if !cashIn && !cashOut && !fee {
            startButton.backgroundColor = UIColor.backColorBT()
        }else {
            startButton.backgroundColor = UIColor.backAlphaColorBT()
        }
    }
}

extension CreateaGameViewController: RadioButtonDelegate {
    func radioButtonDidSelect(_ button: MBRadioButton.RadioButton) {
        if button == ptBT {
            selectFee = true
            feeLabel.text = "%"
        }else {
            selectFee = false
            feeLabel.text = "K"
        }
        UserDefaults.standard.setValue(selectFee, forKey: "feetype")
    }
    
    func radioButtonDidDeselect(_ button: MBRadioButton.RadioButton) {
        
    }
}
