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
    }
    
    func playerConfiguration() {
        nameLabel.text = player?.name
    }
    
    func playerStatusConfiguration() {
        buyInLabel.text = "\(playerStatus?.sumCashIn ?? 0) k"
        cashOutLabel.text = "\(playerStatus?.sumCashOut ?? 0) k"
        if let sumCashOut = playerStatus?.sumCashOut, sumCashOut != 0 {
            let sum = sumCashOut - (playerStatus?.sumCashAfterFee ?? 0)
            if sum < 0 {
                sumLabel.text = "Ban da lo \(sum) k"

            }else {
                sumLabel.text = "Ban da lai \(sum) k"

            }
            cashOutLabel.text = "\(sumCashOut) chip"
            sumLabel.isHidden = false
        } else {
            sumLabel.isHidden = true
        }
        updatePlayButton()
    }
    
    
    func updatePlayButton() {
        if let isActive = playerStatus?.playerActive {
            if isActive {
                playerButton.backgroundColor = .yellow
            } else {
                playerButton.backgroundColor = .lightGray
            }
        } else {
            playerButton.backgroundColor = .lightGray
        }
    }
}
