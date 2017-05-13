//
//  ClockViewController.swift
//  CountDown
//
//  Created by NANZI WANG on 5/8/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ClockViewController: UIViewController {

    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var nextTimeLabel: UILabel!
    
    var scheduleItemsList : [scheduleItemModel] = []
    var diff = DateComponents()
    var currentConvertedMinute = 0
   
    let calendar = Calendar.current
    

    var firstTimeSelected = scheduleItemModel()
    var scheduleConvertedMinuteArray:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRDatabase.database().reference().child("items").child("item1").child("schedule").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let schedule = scheduleItemModel()
            schedule.itemHour = (snapshot.value as! NSDictionary)["hour"] as! Int
            schedule.itemMinute = (snapshot.value as! NSDictionary)["minute"] as! Int
            let scheduleConvertedMinute = schedule.itemHour*60 + schedule.itemMinute //Convert schedule to minutes format
            self.scheduleConvertedMinuteArray.append(scheduleConvertedMinute) //Append Firebase schedules to an array in minutes
            self.scheduleItemsList.append(schedule)
            self.filterFirstTime()
        })
        updateClock()
    }
    
    func filterFirstTime() {
        let date = Date()
        let currentHour = calendar.component(.hour, from: date)
        let currentMinutes = calendar.component(.minute, from: date)
        currentConvertedMinute = currentHour*60 + currentMinutes //Calculate current time in minutes
        let filteredTimesArray = scheduleConvertedMinuteArray.filter{$0 > currentConvertedMinute } // Filter times already passed
        
        if let firstTime = filteredTimesArray.first { // Display the first time in your array, if no more item, show Day Ended
            firstTimeSelected = scheduleItemsList[scheduleConvertedMinuteArray.index(of: firstTime)!]
            nextTimeLabel.text = "\(firstTimeSelected.itemHour) : \(firstTimeSelected.itemMinute)"
        } else {
            nextTimeLabel.text = "Day Ended"
        }
    }
    
    func updateClock() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(compareTime), userInfo: nil, repeats: true)
    }
    
    func compareTime() {
        filterFirstTime()
        let date = Date()
        let calendar = Calendar.current
        let firstSchedule = firstTimeSelected
        let components = DateComponents(calendar: calendar, hour: firstSchedule.itemHour, minute: firstSchedule.itemMinute)
        let nextSchedule = calendar.nextDate(after: date, matching: components, matchingPolicy: .nextTime)!
        diff = calendar.dateComponents([.hour, .minute, .second], from: date, to: nextSchedule)
        clockLabel.text = "\(diff.hour!)h \(diff.minute!)m \(diff.second!)s"
    }
    

}
