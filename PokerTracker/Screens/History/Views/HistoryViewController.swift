//
//  HistoryViewController.swift
//  PlayerGame
//
//  Created by VietChat on 8/4/24.
//

import UIKit

class HistoryViewController: UIViewController {

    var records: [GetGameRecordResult]!
    var gameID: Int!
    var game: Game!
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            records = try GeneralService.getRecordHistory(byGameID: gameID)
            game = try GameTable.find(gameID: gameID)
        } catch {
            print(error.localizedDescription)
        }
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Table view delegate + datasource

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let record = records[indexPath.row]
        let text = record.cashIn > 0 ? "đã nạp \(record.cashIn/game.standardCashIn) chén" : "đã rút \(record.cashOut)K"
        cell.textLabel?.text = "\(record.time.toString()):  \(record.playerName) \(text)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = records[indexPath.row]
//            try GameRecordTable.update(item: gameRecord)
//            try GPlayerStatusTable.deleteARecord(gameRecord: gameRecord)
//            try GPlayerStatusTable.update(withNewMoneyRecord: gameRecord)
        let alertController = UIAlertController(title: "Chỉnh sửa một giao dịch", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Buy in nhiêu chén"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { textField in
            textField.placeholder = "Cash out"
            textField.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            guard let buyInTxt = alertController.textFields?[0].text, let cashOutTxt = alertController.textFields?[1].text else { return }
            do {
                let buyInNum = Int(buyInTxt) ?? 0
                let cashOutNum = Int(cashOutTxt) ?? 0
                if (buyInNum > 0 && cashOutNum > 0) {
                    print("can not fix 2 numbers in a time")
                    return
                }
                try GPlayerStatusTable.deleteARecord(gameRecord: record)
                record.cashIn = buyInNum * self.game.standardCashIn
                record.cashOut = cashOutNum
                try GameRecordTable.update(item: record)
                try GPlayerStatusTable.update(withNewMoneyRecord: record)
                self.historyTableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}
