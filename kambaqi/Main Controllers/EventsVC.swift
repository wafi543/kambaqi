//
//  EventsVC.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 19/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import ARSLineProgress
import Toast_Swift
import GoogleMobileAds

class EventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var AdView: UIView!
    
    var bannerView: GADBannerView!
    var events : [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self; mainTableView.dataSource = self
        getDataOffline()
        getData()
        
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
                let isEventDisabled = defauls.bool(forKey: "\(event.id)-switch")
                if isEventDisabled == false {self.events.append(event)}
            }
            DispatchQueue.main.async {self.mainTableView.reloadData(); ARSLineProgress.hide()}
        } catch {print("Failed")}
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
        do {try context.save()} catch {print("Error. vc: \(self.description ) Line: \(#line)")}
    }
    
    func getData () {
        ARSLineProgress.show()
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
//                core.configureNotificationForEvent(event: event, vc: self)
                let isEventDisabled = defauls.bool(forKey: "\(event.id)-switch")
                if isEventDisabled == false {self.events.append(event)}
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData(); ARSLineProgress.hide()
//                    self.showToast("تم تحديث قائمة الاحداث")
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return events.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        let event = events[indexPath.row]
        cell.Name.text = event.eventName
        
        if event.calendarType == 1 {
            cell.Days.text = "\(core.remainingDays(event.date))"
            cell.EventType.text = "\(core.eventIntervalStr(event.eventInterval)) ميلادي"
        }else {
            cell.Days.text = "\(core.remainingDays(event.date))"
            cell.EventType.text = "\(core.eventIntervalStr(event.eventInterval)) هجري"
        }
        
        if event.eventInterval != 0 {cell.OneTime.text = ""} else {cell.OneTime.text = " - مرة واحدة"}
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {ARSLineProgress.hide()}
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        let message = "adViewDidReceiveAd"
        print(message)
//        self.showToast(message)
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {bannerView.alpha = 1})
        core.addBannerViewToView(bannerView, AdView)
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
