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
    }
    
    func playerConfiguration() {
        nameLabel.text = player?.name
    }
    
    func playerStatusConfiguration() {
        buyInLabel.text = "\(playerStatus?.sumCashIn ?? 0) k"
        cashOutLabel.text = "\(playerStatus?.sumCashOut ?? 0) chip"
        updatePlayButton()
    }
    
    
    func updatePlayButton() {
        if let isActive = playerStatus?.playerActive {
            playerButton.backgroundColor = isActive ? .green : .lightGray
        }
    }
}
