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
import Firebase
import Social
import GoogleMobileAds

class SoonVC: UIViewController, GADBannerViewDelegate {
    @IBOutlet var EventName: UILabel!
    @IBOutlet var Day: UILabel!
    @IBOutlet var Message: UILabel!
    var bannerView: GADBannerView!
    
    var events : [Event] = []
    var nextEvent : Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ARSLineProgress.show()
        getDataOffline()
        
        // Add BannerView of GoogleMobileAds
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = core.BannerID
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    func getDataOffline() {
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
                self.setEvent()
            }
        } catch {print("Failed")}
    }
    
    func setEvent () {
        var sortedEvents = self.events.sorted(by: { $0.date < $1.date })
        var remainingEvents : [Event] = []
        
        if sortedEvents.count > 1 {
            for i in 0...sortedEvents.count-1 {
                if sortedEvents[i].date > Date() {
                    remainingEvents.append(sortedEvents[i])
                }
            }
        }
        
        
        if remainingEvents.count > 0 {
            ARSLineProgress.hide()
            let event = remainingEvents[0]
            self.nextEvent = event
            self.EventName.text = event.eventName
            self.Day.text = "\(core.remainingDays(event.date))"
            self.setMessage(event)
        }else {
//            self.showToast("خطأ، اذا تكرر الخطأ تواصل مع الدعم الفني . SoonVC#\(#line)")
            self.getData()
        }
    }
    
    func getData () {
        dbEvents.observe(.value, with: { (snapshot) in
            self.events.removeAll()
            core.deleteEntity("Events")
            for snp in snapshot.children {
                guard let document = snp as? DataSnapshot else {
                    print("Something wrong with Firebase DataSnapshot")
                    return
                }
                let snapValue = document.value as? NSDictionary
                let id = document.key
                let calendarType = snapValue?.value(forKey: "calendarType") as? Int ?? 0
                let eventInterval = snapValue?.value(forKey: "eventInterval") as? Int ?? 0
                let eventName = snapValue?.value(forKey: "eventName") as? String ?? ""
                let day = snapValue?.value(forKey: "day") as? Int ?? 0
                let month = snapValue?.value(forKey: "month") as? Int ?? 0
                let year = snapValue?.value(forKey: "year") as? Int ?? 0
                
                guard let date = core.generateDate(calendarType, day, month, year) else {return}
                let event = Event.init(id: id, calendarType: calendarType, eventInterval: eventInterval, eventName: eventName, date: date)
                
                self.saveToCoreData(event)
                
                let isEventDisabled = defauls.bool(forKey: "\(event.id)-switch")
                if isEventDisabled == false {self.events.append(event)}
            }
            
            DispatchQueue.main.async {self.setEvent(); ARSLineProgress.hide()}
        })
    }
    
    func saveToCoreData (_ event : Event) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Events", in: context)
        let newObject = NSManagedObject(entity: entity!, insertInto: context)
        
        newObject.setValue(event.id, forKey: "id")
        newObject.setValue(event.calendarType, forKey: "calendarType")
        newObject.setValue(event.eventInterval, forKey: "eventInterval")
        newObject.setValue(event.eventName, forKey: "eventName")
        newObject.setValue(event.date, forKey: "date")
        print(newObject)
        do {try context.save()} catch {print("Error. vc: \(self.description ) Line: \(#line)")}
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
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        let message = "adViewDidReceiveAd"
        print(message)
//        self.showToast(message)
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {bannerView.alpha = 1})
        core.addBannerViewToView(bannerView, view)
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        let message = "adView:didFailToReceiveAdWithError: \(error.localizedDescription)"
        print(message)
//        self.showToast(message)
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
