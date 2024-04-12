//
//  HomeViewController.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            viewModel.fetchGames()
            self.collectionView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func searchOnClick(_ sender: Any) {
        let searchVC = FilterViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    @IBAction func newGameOnClick(_ sender: Any) {
        let createGameVC = CreateaGameViewController()
        navigationController?.pushViewController(createGameVC, animated: true)
    }
}

extension HomeViewController {
    
    func configuration() {
        collectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        initViewModel()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func initViewModel() {
        viewModel.fetchGames()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let games = viewModel.games[indexPath.row]
        cell.games = games
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let gameVC = GameViewController()
        gameVC.gameID = viewModel.games[indexPath.row].id ?? 0
        gameVC.titleGame = "Poker: " + viewModel.games[indexPath.row].time.toString()
        gameVC.cashin = viewModel.games[indexPath.row].standardCashIn
        gameVC.cashOut = viewModel.games[indexPath.row].standardChipOut
        if viewModel.games[indexPath.row].feeTypeInValue {
            gameVC.fee = "\(viewModel.games[indexPath.row].fee) %"
        }else {
            gameVC.fee = "\(viewModel.games[indexPath.row].fee) k"
        }
        
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44)
    }
}
