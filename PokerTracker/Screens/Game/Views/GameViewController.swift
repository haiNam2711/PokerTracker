//
//  GameViewController.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import UIKit
import Toast

class GameViewController: UIViewController {
    
    @IBOutlet weak var nameGameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoTV: UITextView!
    @IBOutlet weak var sumTV: UITextView!
    
    var viewModel = GameViewModel(gameID: 0, titleGame: "", cashin: 0, cashOut: 0, fee: 0, feeBool: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPlayer()
        viewModel.sortPlayersByCashIn(gameID: viewModel.gameID)
        viewModel.getAllPlayerToGame(gameID: viewModel.gameID)
        let sumChen = viewModel.totalCashin / viewModel.cashin
        let cashOutD = Double(viewModel.cashOut)
        let cashInD = Double(viewModel.cashin)
        let totalOutD = Double(viewModel.totalCashOut)
        let sumChip = (totalOutD/cashInD)*cashOutD
        if sumChen == 0 {
            sumTV.text = """
                
            """
        }else {
            sumTV.text = """
                Sum buy: \(sumChen) chén
            
                Sum out: \(Int(sumChip)) chip
            """
        }
        sumTV.text = """
            Sum buy: \(sumChen) chén
        
            Sum out: \(Int(sumChip)) chip
        """
        self.collectionView.reloadData()
    }
    
    @IBAction func backOnClick(_ sender: Any) {
        viewModel.goBackToHome(from: self)
    }
    
    @IBAction func addPlayerOnClick(_ sender: Any) {
        viewModel.showNameAlert(from: self)
        viewModel.reloadDataHandler = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @IBAction func historyGameOnClick(_ sender: Any) {
        viewModel.showHistoryScreen(from: self)
    }
}

extension GameViewController {
    
    func configuration() {
        nameGameLabel.text = viewModel.titleGame
        if viewModel.feeBool {
            infoTV.text = """
                Cashin: \(viewModel.cashin) k
                Chipout: \(viewModel.cashOut) chip
                Fee: \(viewModel.fee) k
            """
        } else {
            infoTV.text = """
                Cashin: \(viewModel.cashin) k
                Chipout: \(viewModel.cashOut) chip
                Fee: \(viewModel.fee) %
            """
        }
        collectionView.register(UINib(nibName: "PlayerCell", bundle: nil), forCellWithReuseIdentifier: "PlayerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        initViewModel()
    }
    
    func initViewModel() {
        viewModel.fetchPlayer()
        viewModel.getAllPlayerToGame(gameID: viewModel.gameID)
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPlayers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        let player = viewModel.player(at: indexPath.row)
        
        if let playerStatus = viewModel.fetchPlayerStatus(gameID: viewModel.gameID, playerID: player.id ?? 0) {
            cell.player = player
            cell.playerStatus = playerStatus
        } else {
            cell.player = player
            cell.playerStatus = nil
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.showPlayerDetailsScreen(at: indexPath.row, navigationController: navigationController)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 58)
    }
}
