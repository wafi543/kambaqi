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
    
}
