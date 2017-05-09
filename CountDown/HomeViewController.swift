//  with 3 same time, but all 3 updating, compare 19:30
//  HomeViewController.swift
//  CountDown
//  Created by NANZI WANG on 4/25/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scheduleTableView: UITableView!
    var scheduleItemsList : [scheduleItemModel] = []
    var now = Date()
    var calendar = Calendar.current
    var diff = DateComponents()
    var nextSchedule = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
        FIRDatabase.database().reference().child("items").child("item1").child("schedule").observe(FIRDataEventType.childAdded, with: { (snapshot) in
//put this below at the wrong spot
            let schedule = scheduleItemModel()
//
            schedule.itemHour = (snapshot.value as! NSDictionary)["hour"] as! Int
            schedule.itemMinute = (snapshot.value as! NSDictionary)["minute"] as! Int
            print("calendar is \(Calendar.current)")
            let components = DateComponents(calendar: self.calendar, hour: schedule.itemHour, minute: schedule.itemMinute)  // time
            self.nextSchedule = self.calendar.nextDate(after: self.now, matching: components, matchingPolicy: .nextTime)!
            self.diff = self.calendar.dateComponents([.hour, .minute, .second], from: self.now, to: self.nextSchedule)
            
            self.scheduleItemsList.append(schedule)
            schedule.itemCountDown = self.diff
            print("viewdidload time is \(schedule.itemHour):\(schedule.itemMinute)")
            self.scheduleTableView.reloadData()
        })
            updateCell()
    }
    
    func updateCell() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(compareTime), userInfo: nil, repeats: true)
    }
    
    func compareTime() {
        now = Date()
        let schedule = scheduleItemsList[2]
        diff = calendar.dateComponents([.hour, .minute, .second], from: now, to: nextSchedule)
        schedule.itemCountDown = diff
        print("Compare time is \(schedule.itemHour):\(schedule.itemMinute)")
        print("Compare diff time is \(diff)")
        scheduleTableView.reloadData()
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleItemsList.count
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell") as! ScheduleTableViewCell
        let schedule = scheduleItemsList[indexPath.row]
        cell.scheduleTime.text = "\(schedule.itemHour) : \(schedule.itemMinute)"
        cell.scheduleCountDown.text = "\(schedule.itemCountDown.hour!) : \(schedule.itemCountDown.minute!) : \(schedule.itemCountDown.second!)"
        print("TableView cell time is \(schedule.itemHour):\(schedule.itemMinute).\(indexPath.row)")
        return cell
    }
}
