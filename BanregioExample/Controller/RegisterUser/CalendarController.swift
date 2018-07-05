//
//  CalendarController.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 01/07/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarController: UIViewController {
    
    @IBOutlet weak var viewModal: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    var selectedMonthColor = UIColor.white
    var thisMonthColor = UIColor.black
    var notThisMonthColor = UIColor.gray

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModal.layer.cornerRadius = 10
        viewModal.clipsToBounds = true
    }
    
    func setupCalendar(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        guard let cell = view as? CalendarCell else {return}
        
        if cellState.isSelected{
            cell.lblDate.textColor = selectedMonthColor
        }else{
            if cellState.dateBelongsTo == .thisMonth{
                cell.lblDate.textColor = thisMonthColor
            }else{
                cell.lblDate.textColor = notThisMonthColor
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let cell = view as? CalendarCell else { return }
        cell.viewCircle.isHidden = cellState.isSelected ? false : true
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CalendarController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        print("will display")
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let endDate = Date()
        let startDate = Date().substractYears(years: 70)
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
}

extension CalendarController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.lblDate.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("didSelectDate: ",cellState.isSelected)
        handleCellSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("didDeselectDate: ",cellState.isSelected)
        handleCellSelected(view: cell, cellState: cellState)
    }
}
