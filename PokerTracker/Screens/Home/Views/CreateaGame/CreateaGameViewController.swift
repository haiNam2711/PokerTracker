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
    
    var groupContainer = RadioButtonContainer()
    private var viewModel = CreateGameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    @IBAction func startGameOnClick(_ sender: Any) {
        viewModel.createGame(from: self, cashIn: cashInTF.text, cashOut: cashOutTF.text, fee: feeTF.text, feeType: viewModel.feeType)
    }
    
    @IBAction func backButton(_ sender: Any) {
        viewModel.backClick(from: self)
    }
}

extension CreateaGameViewController {
    
    func configuration() {
        cashInTF.layer.borderColor = UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3).cgColor
        cashOutTF.layer.borderColor = UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3).cgColor
        feeTF.layer.borderColor = UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3).cgColor
        startButton.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3)
        cashInTF.becomeFirstResponder()
        cashInTF.delegate = self
        cashOutTF.delegate = self
        feeTF.delegate = self
        cashInTF.addPadding(.left(8))
        cashOutTF.addPadding(.left(8))
        feeTF.addPadding(.left(8))
        groupContainer.addButtons([ptBT, kBT])
        groupContainer.delegate = self
        configurationVM()
    }
    
    func configurationVM() {
        viewModel.loadUserDefaults()
        cashInTF.text = viewModel.cashIn
        cashOutTF.text = viewModel.cashOut
        feeTF.text = viewModel.fee
        groupContainer.selectedButton = viewModel.feeType ? kBT : ptBT
        feeLabel.text = viewModel.feeType ? "K" : "%"
    }
}

extension CreateaGameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor =  UIColor.hexStringToUIColor(hex: "D83842").cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor =  UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3).cgColor
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let cashInEmpty = (cashInTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let cashOutEmpty = (cashOutTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let feeEmpty = (feeTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let cashInZero = (cashInTF.text ?? "0").trimmingCharacters(in: .whitespacesAndNewlines) == "0"
        let cashOutZero = (cashOutTF.text ?? "0").trimmingCharacters(in: .whitespacesAndNewlines) == "0"
        
        startButton.backgroundColor = cashInEmpty || cashOutEmpty || feeEmpty || cashInZero || cashOutZero ? UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3) : UIColor.hexStringToUIColor(hex: "D83842")
        
    }
}

extension CreateaGameViewController: RadioButtonDelegate {
    func radioButtonDidSelect(_ button: MBRadioButton.RadioButton) {
        viewModel.feeType = button == kBT
        feeLabel.text = viewModel.feeType ? "K" : "%"
    }
    
    func radioButtonDidDeselect(_ button: MBRadioButton.RadioButton) {
        
    }
}
