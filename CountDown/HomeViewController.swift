//
//  HomeViewController.swift
//  CountDown
//
//  Created by NANZI WANG on 4/25/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scheduleTableView: UITableView!
    var scheduleItems : [scheduleItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
        FIRDatabase.database().reference().child("items").child("item1").child("schedule").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let schedule = scheduleItem()
            let now = Date()
            let calendar = Calendar.current
            
            schedule.itemHour = (snapshot.value as! NSDictionary)["hour"] as! Int
            schedule.itemMinute = (snapshot.value as! NSDictionary)["minute"] as! Int
            
            let components = DateComponents(calendar: calendar, hour: schedule.itemHour, minute: schedule.itemMinute)  // time
            let nextSchedule = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
            let diff = calendar.dateComponents([.hour, .minute, .second], from: now, to: nextSchedule)
            self.scheduleItems.append(schedule)
            schedule.itemCountDown = diff
        self.scheduleTableView.reloadData()
        })
    }
    
    func updateCell() {
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.compareTime), userInfo: nil, repeats: true)
    }
    
    func compareTime() {
        self.scheduleTableView.reloadData()
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleItems.count
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell") as! ScheduleTableViewCell
        let schedule = scheduleItems[indexPath.row]
        cell.scheduleTime.text = "\(schedule.itemHour) : \(schedule.itemMinute)"
        cell.scheduleCountDown.text = "\(schedule.itemCountDown.hour!) : \(schedule.itemCountDown.minute!) : \(schedule.itemCountDown.second!)"
        return cell
    }
}

