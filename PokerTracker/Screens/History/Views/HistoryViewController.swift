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
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            records = try GeneralService.getRecordHistory(byGameID: gameID!)
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
        let text = record.cashIn > 0 ? "đã nạp \(record.cashIn)" : "đã rút \(record.cashOut)"
        cell.textLabel?.text = "\(record.time.toString()):  \(record.playerName) \(text)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
}
