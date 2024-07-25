//
//  HomeCollectionViewCell.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet weak var nameGameLabel: UILabel!
    @IBOutlet weak var playGameButton: UIButton!
    
    var games: Game? {
        didSet {
            gameDetailConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func gameDetailConfiguration() {
        guard let games = games else { return }
        nameGameLabel.text = "Poker: " + games.time.toDateTimeString()
    }
}
