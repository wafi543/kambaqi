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
        case names.mainTitles[3]:
            return mainStoryBoard.instantiateViewController(withIdentifier: "TodayVC")
        case names.mainTitles[4]:
            return mainStoryBoard.instantiateViewController(withIdentifier: "AdsVC")
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
}
