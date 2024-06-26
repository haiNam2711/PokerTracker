//
//  MemberCollectionViewCell.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import UIKit

class PlayerCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buyInLabel: UILabel!
    @IBOutlet weak var cashOutLabel: UILabel!
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var buyibLB: UILabel!
    @IBOutlet weak var chipOutLB: UILabel!
    
    var player: Player? {
        didSet {
            playerConfiguration()
        }
    }
    
    var playerStatus: GPlayerStatus? {
        didSet {
            playerStatusConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sumLabel.isHidden = true
        colorDefault()
    }
    
    func playerConfiguration() {
        nameLabel.text = player?.name
    }
    
    func playerStatusConfiguration() {
        buyInLabel.text = "\(playerStatus?.sumCashAfterFee ?? 0) k"
        cashOutLabel.text = "\(playerStatus?.sumCashOut ?? 0) k"
        updatePlayButton()
        if let sumCashOut = playerStatus?.sumCashOut {
            let sum = sumCashOut - (playerStatus?.sumCashAfterFee ?? 0)
            if sum == 0 {
                sumLabel.text = "Hòa vốn"
                colorYellow()
            }else if sum > 0 {
                sumLabel.text = "Lãi \(sum) k"
                colorGreen()
            }else {
                sumLabel.text = "Lỗ \(sum) k"
                colorRed()
            }
            cashOutLabel.text = "\(sumCashOut) k"
            sumLabel.isHidden = false
        } else {
            sumLabel.isHidden = true
        }
    }
    
    
    func updatePlayButton() {
        if let isActive = playerStatus?.playerActive {
            if isActive {
                playerButton.backgroundColor = .yellow
            } else {
                colorDefault()
            }
        } else {
            colorDefault()
        }
    }
    
    func colorYellow() {
        playerButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#F2E318")
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "#F2E318")
        lineView.backgroundColor = .black.withAlphaComponent(0.3)
        nameLabel.textColor = .black
        buyibLB.textColor = .black
        chipOutLB.textColor = .black
        buyInLabel.textColor = .black
        cashOutLabel.textColor = .black
        sumLabel.textColor = .black
        playerButton.tintColor = .black
    }
    
    func colorRed() {
        playerButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#EB442C")
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "#EB442C")
        lineView.backgroundColor = .black.withAlphaComponent(0.3)
        nameLabel.textColor = .white
        buyibLB.textColor = .white
        chipOutLB.textColor = .white
        buyInLabel.textColor = .white
        cashOutLabel.textColor = .white
        sumLabel.textColor = .white
        playerButton.tintColor = .white
    }
    
    func colorGreen() {
        playerButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#74C69D")
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "#74C69D")
        lineView.backgroundColor = .black.withAlphaComponent(0.3)
        nameLabel.textColor = .white
        buyibLB.textColor = .white
        chipOutLB.textColor = .white
        buyInLabel.textColor = .white
        cashOutLabel.textColor = .white
        sumLabel.textColor = .white
        playerButton.tintColor = .white
    }
    
    func colorDefault() {
        playerButton.backgroundColor = .white
        view.backgroundColor = .white
        lineView.backgroundColor = .black.withAlphaComponent(0.3)
        nameLabel.textColor = .black
        buyibLB.textColor = .black
        chipOutLB.textColor = .black
        buyInLabel.textColor = .black
        cashOutLabel.textColor = .black
        sumLabel.textColor = .black
        playerButton.tintColor = .black
    }
}
