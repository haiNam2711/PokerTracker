//
//  PlayerViewController.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import UIKit

class PlayerViewController: UIViewController {
    
    var viewModel = PlayerViewModel(name: "", gameID: 0, playerID: 0, cashIn: 0, cashOut: 0)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cashInLabel: UILabel!
    @IBOutlet weak var cashOutTF: UITextField!
    @IBOutlet weak var deleteBT: UIButton!
    @IBOutlet weak var moreBT: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }
    
    deinit {
        unregisterObserver()
    }
    
    
    @IBAction func okOnclick(_ sender: Any) {
        viewModel.handleOKButton(from: self, chipOutText: cashOutTF.text)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let cashOutOld = Int((Float(viewModel.player.sumCashOut)/Float(viewModel.cashIn))*Float(viewModel.cashOut))
        if cashOutOld == 0 {
            if viewModel.amount > 0 {
                viewModel.amount -= 1
                cashInLabel.text = "\(viewModel.amount)"
                deleteBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842")
            }
        }else {
            if viewModel.amount > 1 {
                viewModel.amount -= 1
                cashInLabel.text = "\(viewModel.amount)"
                deleteBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842")
            }
        }
        
        if viewModel.amount == 0 {
            deleteBT.isEnabled = true
            deleteBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3)
        }
        if viewModel.amount == viewModel.amonutOld {
            cashOutTF.isEnabled = true
            
        }else {
            cashOutTF.isEnabled = false
        }
    }
    
    @IBAction func moreAction(_ sender: Any) {
        viewModel.amount += 1
        cashInLabel.text = "\(viewModel.amount)"
        deleteBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842")
        if viewModel.amount == viewModel.amonutOld {
            cashOutTF.isEnabled = true
            
        }else {
            cashOutTF.isEnabled = false
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        viewModel.backClick(from: self)
    }
    @IBAction func updateNameAction(_ sender: Any) {
        viewModel.showRenameAlert(from: self)
        viewModel.reloadDataHandler = { [weak self] name in
            self?.nameLabel.text = name
        }
    }
}

extension PlayerViewController {
    
    func configuration() {
        nameLabel.text = viewModel.name
        viewModel.fetchPlayerStatus()
        viewModel.amount = viewModel.player.sumCashIn / viewModel.cashIn
        viewModel.amonutOld = viewModel.player.sumCashIn / viewModel.cashIn
        cashInLabel.text = "\(viewModel.amount)"
        cashOutTF.layer.borderColor = UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3).cgColor
        cashOutTF.delegate = self
        deleteBT.backgroundColor = viewModel.amount > 0 ? UIColor.hexStringToUIColor(hex: "D83842") : UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3)
        
        let cashOutOld = Int((Float(viewModel.player.sumCashOut)/Float(viewModel.cashIn))*Float(viewModel.cashOut))
        if cashOutOld != 0 {
            cashOutTF.text = "\(cashOutOld)"
            deleteBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842")
            moreBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842")
        }
        cashOutTF.addPadding(.left(8))
        registerObserver()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func unregisterObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0
        
        UIView.animate(withDuration: duration) {[weak self] in
            guard let self = self else { return}
            
            self.okButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + self.safeAreaInsets.bottom)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0
        
        UIView.animate(withDuration: duration) {[weak self] in
            guard let self = self else { return}
            
            self.okButton.transform = .identity
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension PlayerViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor =  UIColor.hexStringToUIColor(hex: "D83842").cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor =  UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3).cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if viewModel.amount == 0 {
            return false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let cashOutOld = Int((Float(viewModel.player.sumCashOut)/Float(viewModel.cashIn))*Float(viewModel.cashOut))
        let text = cashOutTF.text
        let cashOutString = String(cashOutOld)
        if cashOutString == "0" || text == cashOutString {
            deleteBT.isEnabled = true
            moreBT.isEnabled = true
            deleteBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842")
            moreBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842")
        }else {
            deleteBT.isEnabled = false
            moreBT.isEnabled = false
            deleteBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3)
            moreBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3)
        }
    }
}
