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
    
    @IBAction func searchOnClick(_ sender: Any) {
        
    }
    @IBAction func newGameOnClick(_ sender: Any) {
        let createGameVC = CreateaGameViewController()
        let nav = UINavigationController(rootViewController: createGameVC)
        nav.modalPresentationStyle = .popover
        present(nav, animated: true)
    }
}

extension HomeViewController {
    
    func configuration() {
        collectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        initViewModel()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.eventHandler = { [weak self] event in
            DispatchQueue.main.async {
                switch event {
                case .dataUpdate:
                    self?.collectionView.reloadData()
                }
            }
        }
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
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44)
    }
}
