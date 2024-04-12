//
//  GameViewController.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import UIKit
import Toast

class GameViewController: UIViewController {

    var titleGame: String = ""
    var cashin: Int = 0
    var cashOut: Int = 0
    var fee: String = ""
    var playerID = 0
    var gameID = 0
    
    @IBOutlet weak var nameGameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoTV: UITextView!
    
    private var viewModel = GameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }

    @IBAction func backOnClick(_ sender: Any) {
        if let homeVC = navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
            navigationController?.popToViewController(homeVC, animated: true)
        }
    }
    @IBAction func addPlayerOnClick(_ sender: Any) {
        showNameAlert()
    }
    
    @IBAction func historyGameOnClick(_ sender: Any) {
        let historyVC = HistoryViewController()
        historyVC.gameID = self.gameID
        navigationController?.pushViewController(historyVC, animated: true)
    }
}

extension GameViewController {
    
    func configuration() {
        nameGameLabel.text = titleGame
        infoTV.text = """
            Cashin: \(cashin) k
            Chipout: \(cashOut) chip
            Fee: \(fee)
        """
        collectionView.register(UINib(nibName: "PlayerCell", bundle: nil), forCellWithReuseIdentifier: "PlayerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        initViewModel()
    }
    
    func initViewModel() {
        viewModel.fetchPlayer()
    }
    
    func showNameAlert() {
        let alertController = UIAlertController(title: "Thêm người chơi mới", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Tên của bạn"
        }
        
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if let name = alertController.textFields?.first?.text {
                let player = Player(name: name)
                self?.viewModel.createNewPlayer(player: player)
                if self?.viewModel.success == true {
                    self?.view.makeToast("Thêm người chơi thành công")
                }else {
                    self?.view.makeToast("Người chơi đã tồn tại hoặc có lỗi đã xảy ra")
                }
                self?.collectionView.reloadData()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        let player = viewModel.players[indexPath.row]
        cell.player = player
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let namePlayer = viewModel.players[indexPath.row].name
        let idPlayer = viewModel.players[indexPath.row].id
        let vc = PlayerViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.name = namePlayer
        vc.idGame = gameID
        vc.idPlayer = idPlayer ?? 0
        vc.cashIn = Int(cashin) ?? 0
        print("debug \(vc.idPlayer)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 52)
    }
}
