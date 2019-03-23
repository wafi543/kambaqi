//
//  Core.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 19/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import Foundation
import UIKit
import ARSLineProgress
import Firebase
import CoreData
import UserNotifications

// Public Declaration
let defauls = UserDefaults.standard
let core = Core()
let helper = Helper()
let names = Names()
let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
let dbEvents = Database.database().reference().child("Events")
let dbPhotos = Database.database().reference().child("Photos")
let dateFormatterStr = "yyyy/MM/dd"


class Core {
    let Copyright = "Copyright © 2019 Wafi Alshammari. All rights reserved."
    let DeveloperName = "وافي أحمد الشمري"
    let AppName = "kambaqi"
    let DeveloperEmail = "wafi543@outlook.sa"
    let DeveloperPhone = "+966570634459"
    let AppURL = "https://itunes.apple.com/app/id1447849679"
    let BannerID = "ca-app-pub-5725271673199016/9866202148" // you shouuld update
    let DeviceModel = UIDevice.current.model
    let SystemVersion = UIDevice.current.systemVersion
    let myFormatter : DateFormatter = {let formatter = DateFormatter(); formatter.dateFormat = "yyyy/MM/dd"; return formatter} ()
    
    func mainVCs (_ title : String) -> UIViewController? {
        switch title {
        case names.mainTitles[0]:
            return mainStoryBoard.instantiateViewController(withIdentifier: "SoonVC")
        case names.mainTitles[1]:
            return mainStoryBoard.instantiateViewController(withIdentifier: "EventsVC")
        case names.mainTitles[2]:
            return mainStoryBoard.instantiateViewController(withIdentifier: "MyEventsVC")
        case names.mainTitles[3]:
            return mainStoryBoard.instantiateViewController(withIdentifier: "TodayVC")
        case names.mainTitles[4]:
            return mainStoryBoard.instantiateViewController(withIdentifier: "AdsVC")
        case names.mainTitles[5]:
            return mainStoryBoard.instantiateViewController(withIdentifier: "SettingVC")
        default:
            return nil
        }
    }
    
    func generateDate (_ calendarType : Int,_ day : Int,_ month : Int,_ year : Int) -> Date? {
        if calendarType == 1 {
            return "\(year)/\(month)/\(day)".toDate(dateFormatterStr, "en")
        }else {
            return "\(year)/\(month)/\(day)".toDate(dateFormatterStr, "en_SA")
        }
    }
    
    func eventIntervalStr (_ eventInterval : Int) -> String {
        switch eventInterval {
        case 1:
            return "شهري"
        case 2:
            return "سنوي"
        default:
            return ""
        }
    }
    
    func remainingDays (_ date : Date) -> Int {
//        var date2 = date
//        if date2 < Date() {if Date().days(from: date2) > 0 {date2.addDaysComponent(365)} else {return 0}}
//        let days = date2.days(from: Date())
//        if date2.hours(from: Date()) % 24 > 1 {return days + 1} else {return days}
        
        var date2 = date; if date2 < Date() {date2.addDaysComponent(365)}
        let days = date2.days(from: Date())
        if date2.hours(from: Date()) % 24 > 1 {return days + 1}else {return days}
    }
    
    func deleteEntity (_ entity : String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        
        do {
            let incidents = try context.fetch(request)
            if incidents.count > 0 {
                for result in incidents {
                    context.delete(result as! NSManagedObject)
                    print("NSManagedObject has been Deleted")
                }
                try context.save()
            }
        } catch {}
    }
    
    func decColor (_ name : String) -> UIColor {
        switch name {
        case names.colorNames[1]:
            return colors.orange
        case names.colorNames[2]:
            return colors.cyan
        case names.colorNames[3]:
            return colors.yellow
        case names.colorNames[4]:
            return colors.green
        default:
            return UIColor.white
        }
    }
    
    func configureNotification (myEvent : MyEvent, vc : UIViewController) {
        print("configureNotification : \(myEvent.eventName), id: MyEvent-\(myEvent.id)")
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = myEvent.eventName
        content.body = "حان الوقت"
        let date = myEvent.date
        let identifier = "Kambaqi-MyEvents-\(myEvent.id)"
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if error != nil {Helper.showErrorMessage(error, #line, vc); return}
            print("Notification has been added successfully. for : \(myEvent.eventName)")
        })
    }
    
    func removePendingNotification (_ myEvent : MyEvent) {
        print("removePendingNotification: \(myEvent.eventName)")
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            
            for notification in notificationRequests {
                if notification.identifier == "Kambaqi-MyEvents-\(myEvent.id)" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
//    
//    func configureNotificationForEvent (event : Event, vc : UIViewController) {
//        print("configureNotification : \(event.eventName), id: \(event.id)")
//        let content = UNMutableNotificationContent()
//        content.sound = UNNotificationSound.default
//        content.title = event.eventName
//        content.body = "حان الوقت"
//        let date = event.date
//        let identifier = "Kambaqi-Events-\(event.id)"
//        
//        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
////        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//        let request = UNNotificationRequest(identifier: identifier,
//                                            content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
//            if error != nil {Helper.showErrorMessage(error, #line, vc); return}
//            print("Notification has been added successfully. for : \(event.eventName)")
//        })
//    }
//    

    func minSpacing (height : CGFloat) -> CGFloat {
        print(height)
        switch height {
        case 812:
            return 40
        case 896:
            return 60
        case 736:
            return 40
        default:
            return 10
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView, _ view : UIView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
}
