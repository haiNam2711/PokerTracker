//
//  DatePickerView.swift
//  PokerTracker
//
//  Created by Hai Nam on 16/4/24.
//

import UIKit

class DatePickerView: UIView {

    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var yearPickerView: UIPickerView!
    var doneButtonAction: () -> Void = {}
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBAction func doneButtonTapped(_ sender: Any) {
        doneButtonAction()
    }
}
