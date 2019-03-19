//
//  SoonVC.swift
//  Kambaqi
//
//  Created by Wafi Alshammari on 19/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit
import CoreData
import ARSLineProgress
import Social

class SoonVC: UIViewController {
    @IBOutlet var EventName: UILabel!
    @IBOutlet var Day: UILabel!
    @IBOutlet var Message: UILabel!
    
    var events : [Event] = []
    var nextEvent : Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataOffline()
    }
    
    func getDataOffline() {
        ARSLineProgress.show()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
        request.returnsObjectsAsFaults = false
        do {
            self.events.removeAll()
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "id") as? String ?? ""
                let calendarType = data.value(forKey: "calendarType") as? Int ?? 0
                let eventInterval = data.value(forKey: "eventInterval") as? Int ?? 0
                let eventName = data.value(forKey: "eventName") as? String ?? ""
                let date = data.value(forKey: "date") as? Date ?? Date()
                
                let event = Event.init(id: id, calendarType: calendarType, eventInterval: eventInterval, eventName: eventName, date: date)
                self.events.append(event)
            }
            
            DispatchQueue.main.async {
                var sortedEvents = self.events.sorted(by: { $0.date < $1.date })
                var remainingEvents : [Event] = []
                
                if sortedEvents.count > 1 {
                    for i in 0...sortedEvents.count-1 {
                        if sortedEvents[i].date > Date() {
                            remainingEvents.append(sortedEvents[i])
                        }
                    }
                }
                
                let event = remainingEvents[0]
                self.nextEvent = event
                self.EventName.text = event.eventName
                self.Day.text = "\(core.remainingDays(event.date))"
                self.setMessage(event)
                ARSLineProgress.hide()
            }
        } catch {print("Failed")}
    }
    
    func setMessage (_ event : Event) {
        var eventInterveal : String = ""
        var eventCalender : String = ""
        
        if  event.eventInterval == 0 {
            eventInterveal = "يحدث مرة واحدة"
        }else if event.eventInterval == 1 {
            eventInterveal = "يتكرر شهريا"
        }else{
            eventInterveal = "يتكرر سنويا"
        }
        
        if event.calendarType == 0 {
            eventCalender = "هجري"
        }else{
            eventCalender = "ميلادي"
        }
        
        let text1 = "هذا الحدث"
        let text2 = "حسب التقويم"
        Message.text = "\(text1) \(eventInterveal) \(text2) \(eventCalender)"
    }
    
    @IBAction func tweet(_ sender: Any) {
        var urlStr = "https://twitter.com/intent/tweet?text=لقد تبقى \(core.remainingDays(nextEvent.date)) يوم لكي يحين موعد \(nextEvent.eventName)"
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print(urlStr)
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else {
            print("error make url")
        }
    }
    
}
