//
//  FilterViewController.swift
//  PokerTracker
//
//  Created by Hai Nam on 11/4/24.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var resultTableView: UITableView!
    var items = [PlayerProfitOrLoss]()
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "filterResultCell")
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        do {
            var start = startDatePicker.date.get(.day, .month, .year)
            var end = endDatePicker.date.get(.day, .month, .year)
            print(start, end)
            start.hour = 0
            end.hour = 24
            items = try PlayerTable.getPlayersProfitOrLoss(from: Calendar.current.date(from: start)!, to: Calendar.current.date(from: end)!)
            print("items: \(items.count)")
            resultTableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Tableview Delegate, Datasource
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: "filterResultCell", for: indexPath)
        let money = items[indexPath.row].money
        let txt = money > 0 ? "đã lãi \(money)" : "đã lỗ \(-money)"
        cell.textLabel?.text = "\(items[indexPath.row].name) \(txt)"
        print(1)
        return cell
    }
}
