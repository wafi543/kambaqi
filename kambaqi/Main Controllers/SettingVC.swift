//
//  SettingVC.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 20/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit
import CoreData
import ARSLineProgress
import GoogleMobileAds

class SettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var AdView: UIView!
    
    var events : [Event] = []
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self; mainTableView.dataSource = self
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
            DispatchQueue.main.async {self.mainTableView.reloadData(); ARSLineProgress.hide()}
        } catch {print("Failed")}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return events.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        
        let event = events[indexPath.row]
        cell.toggle.tag = indexPath.row
        cell.toggle.addTarget(self, action: #selector(self.eventToggle(sender:)), for: .touchUpInside)
        cell.EventName.text = event.eventName
        
        let isEventDisabled = defauls.bool(forKey: "\(event.id)-switch")
        if isEventDisabled {
            cell.toggle.setImage(UIImage(named: "disabled-icon"), for: .normal)
        }else {
            cell.toggle.setImage(UIImage(named: "enabled-icon"), for: .normal)
        }
        return cell
    }
    
    @objc func eventToggle (sender : UIButton) {
        print("eventToggle : \(sender.tag)")
        let event = events[sender.tag]
        let isEventDisabled = defauls.bool(forKey: "\(event.id)-switch")
        
        defauls.set(isEventDisabled.getReverse(), forKey: "\(event.id)-switch")
        mainTableView.reloadData()
        
    }
    
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
