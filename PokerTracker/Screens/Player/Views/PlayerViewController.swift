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
        if viewModel.amount <= viewModel.amonutOld {
            deleteBT.isEnabled = false
            deleteBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842")
        } else {
            viewModel.amount -= 1
            cashInLabel.text = "\(viewModel.amount)"
            
            if viewModel.amount <= viewModel.amonutOld {
                deleteBT.isEnabled = false
                deleteBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3)
            }
        }
        
    }
    
    @IBAction func moreAction(_ sender: Any) {
        viewModel.amount += 1
        cashInLabel.text = "\(viewModel.amount)"
        
        if viewModel.amount > viewModel.amonutOld {
            deleteBT.isEnabled = true
            deleteBT.backgroundColor = UIColor.hexStringToUIColor(hex: "D83842")
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
        
        deleteBT.isEnabled = viewModel.amonutOld > viewModel.amount
        deleteBT.backgroundColor = viewModel.amonutOld > viewModel.amount ? UIColor.hexStringToUIColor(hex: "D83842") : UIColor.hexStringToUIColor(hex: "D83842").withAlphaComponent(0.3)
        registerObserver()
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
}

