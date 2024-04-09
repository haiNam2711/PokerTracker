//
//  HomeViewController.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
//            try GeneralService.cashInOrCashOut(gameRecord: GameRecord(gameID: 1, time: Date(), playerID: 1, cashIn: 100, cashOut: 0))
//            let res = try GeneralService.getPlayers(byGameID: 1)
//            print(res)
//            let res2 = try GeneralService.getRecordHistory(byGameID: 1)
//            print(res2)
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func searchOnClick(_ sender: Any) {
        
    }
    @IBAction func newGameOnClick(_ sender: Any) {

    }
}
