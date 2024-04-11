//
//  GameViewController.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import UIKit

class GameViewController: UIViewController {

    var titleGame: String = ""
    var cashin: String = ""
    var cashOut: String = ""
    var fee: String = ""
    
    @IBOutlet weak var nameGameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }

    @IBAction func backOnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func historyGameOnClick(_ sender: Any) {
        
    }
}

extension GameViewController {
    
    func configuration() {
        nameGameLabel.text = titleGame
        infoTV.text = """
            Cashin: \(cashin)
            Cashout: \(cashOut)
            Fee: \(fee)
        """
        collectionView.register(UINib(nibName: "PlayerCell", bundle: nil), forCellWithReuseIdentifier: "PlayerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 48)
    }
}
