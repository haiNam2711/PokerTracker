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
        viewModel.fetchGames()
        self.collectionView.reloadData()
    }
    
    @IBAction func searchOnClick(_ sender: Any) {
        viewModel.showFilterScreen(from: self)
    }
    @IBAction func newGameOnClick(_ sender: Any) {
        viewModel.showCreateGameScreen(from: self)
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
        return viewModel.numberOfGames
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let game = viewModel.game(at: indexPath.row)
        cell.games = game
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.showGameDetailsScreen(at: indexPath.row, navigationController: navigationController)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44)
    }
}
