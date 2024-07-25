//
//  FilterViewController.swift
//  PokerTracker
//
//  Created by Hai Nam on 11/4/24.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var resultTableView: UITableView!
    var items = [PlayerProfitOrLoss]()
    var fromDate: Date = Date()
    var toDate: Date = Date()
    var datePickerView: DatePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "filterResultCell")
        setUpDatePickerView()
        fromDateLabel.text = Date().toDMY()
        toDateLabel.text = Date().toDMY()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let screenHeight = UIScreen.main.bounds.height
        let customViewHeight = screenHeight / 3
        let customViewY = screenHeight - customViewHeight
        datePickerView.frame = CGRect(x: 0, y: customViewY, width: view.bounds.width, height: customViewHeight)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        datePickerView.removeFromSuperview()
    }
    
    func setUpDatePickerView() {
        if let customView = Bundle.main.loadNibNamed("DatePickerView", owner: nil, options: nil)?.first as? DatePickerView {
            datePickerView = customView
        }
    }
    
    @IBAction func fromDateTapped(_ sender: UIButton) {
        showDatePicker(label: fromDateLabel)
    }
    
    @IBAction func toDateTapped(_ sender: UIButton) {
        showDatePicker(label: toDateLabel)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        datePickerView.removeFromSuperview()
        do {
            var start = fromDate.get(.day, .month, .year)
            var end = toDate.get(.day, .month, .year)
            print(start, end)
            start.hour = 0
            end.hour = 24
            let queryStart = Calendar.current.date(from: start)!
            let queryEnd = Calendar.current.date(from: end)!
            if queryStart > queryEnd {
                let alert = UIAlertController(title: "Error", message: "From date is after To date", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                items = try PlayerTable.getPlayersProfitOrLoss(from: queryStart, to: queryEnd)
                print("items: \(items.count)")
                resultTableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func showDatePicker(label: UILabel) {
        view.addSubview(datePickerView)
        if label == fromDateLabel {
            datePickerView.datePickerView.date = fromDate
        } else {
            datePickerView.datePickerView.date = toDate
        }
        datePickerView.doneButtonAction = { [weak self] in
            self?.datePickerView.removeFromSuperview()
            let date = self?.datePickerView.datePickerView.date
            label.text = date!.toDMY()
            if label == self?.fromDateLabel {
                self?.fromDate = date!
            } else {
                self?.toDate = date!
            }
        }
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
