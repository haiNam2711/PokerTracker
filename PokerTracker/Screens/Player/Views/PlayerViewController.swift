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
    var amonutOld = 0
    
    private let viewModel = PlayerViewModel()
    
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
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func okOnclick(_ sender: Any) {
        var sumOut = 0
        guard let cashOut = cashOutTF.text, !cashOut.isEmpty else {
            sum = cashIn * amount
            if sum != 0 {
                viewModel.cashInOrCashOut(gameRecord: GameRecord(gameID: idGame, time: Date(), playerID: idPlayer, cashIn: sum-viewModel.player.sumCashIn, cashOut: 0))
                navigationController?.popViewController(animated: true)
            }
            return
        }
        
        guard let cashOut = Int(cashOut) else {
            return
        }
        sum = cashIn * amount
        
        viewModel.cashInOrCashOut(gameRecord: GameRecord(gameID: idGame, time: Date(), playerID: idPlayer, cashIn: sum-viewModel.player.sumCashIn, cashOut: cashOut))
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if amount <= amonutOld {
            
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
    @IBAction func updateNameAction(_ sender: Any) {
        renamePlayer()
    }
}

extension PlayerViewController {
    
    func configuration() {
        nameLabel.text = name
        viewModel.fetchPlayerStatus(gameID: idGame, playerID: idPlayer)
        print(viewModel.player.sumChip)
        amount = viewModel.player.sumCashIn / cashIn
        amonutOld = viewModel.player.sumCashIn / cashIn
        cashInLabel.text = "\(amount)"
        registerObserver()
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
    
    func renamePlayer() {
        let alertController = UIAlertController(title: "Thay đổi tên", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = self.name
        }
        
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if let name = alertController.textFields?.first?.text {
                self?.viewModel.updateName(playerID: self?.idPlayer ?? 0, name: name)
                self?.nameLabel.text = name
                self?.view.makeToast("Thay đổi tên thành công")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
        
    }
}
