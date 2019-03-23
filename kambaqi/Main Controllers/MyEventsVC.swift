//
//  MyEventsVC.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 20/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit
import CoreData
import ARSLineProgress
import UserNotifications
import GoogleMobileAds

class MyEventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    @IBOutlet var mainTableView: UITableView!
    
    var bannerView: GADBannerView!
    var myEvents : [MyEvent] = []
    
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
        ARSLineProgress.show()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyEvents")
        request.returnsObjectsAsFaults = false
        do {
            self.myEvents.removeAll()
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "id") as? Int ?? 0
                let calendarType = data.value(forKey: "calendarType") as? Int ?? 0
                let eventName = data.value(forKey: "eventName") as? String ?? ""
                let date = data.value(forKey: "date") as? Date ?? Date()
                let color = data.value(forKey: "color") as? Int ?? 0
                let alertStatus = data.value(forKey: "alertStatus") as? Bool ?? false
                let myEvent = MyEvent.init(id: id, eventName: eventName, calendarType: calendarType, date: date, color: color, alertStatus: alertStatus)
                self.myEvents.append(myEvent)
            }
            DispatchQueue.main.async {self.mainTableView.reloadData(); ARSLineProgress.hide()}
        } catch {print("Failed")}
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        getDataOffline()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataOffline()
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        if let id = myEvents.last?.id {vc.lastIndex = id + 1} else {vc.lastIndex = 0}
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return self.myEvents.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventCell", for: indexPath) as! MyEventCell
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(self.edit(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(self.delete(sender:)), for: .touchUpInside)
        
        let myEvent = myEvents[indexPath.row]
        cell.myEvent = myEvent
        cell.View.backgroundColor = core.decColor(names.colorNames[myEvent.color])
        cell.EventName.text = myEvent.eventName
        cell.configureShapesAndTimer()
        return cell
    }
    
    @objc func edit(sender : UIButton) {
        let myEvent = myEvents[sender.tag]
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        vc.vcType = .EditVC
        vc.myEvent = myEvent
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func delete(sender : UIButton) {
        func deleteEvent(withID: Int, completion: (() -> ())?) {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyEvents")
            fetchRequest.predicate = NSPredicate.init(format: "id==\(withID)")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
                try context.save()
                completion?()
            } catch {
                print ("There was an error")
            }
        }
        
        self.showTwoActions(title: "تأكيد الحذف", subtitle: "سيتم حذف عنصر، هل أنت متأكد؟", actionTitle: "تأكيد", cancelTitle: "إلغاء", actionStyle: .destructive, cancelStyle: .default, cancelHandler: nil) { (_) in
            // delete object
            let myEvent = self.myEvents[sender.tag]
            deleteEvent(withID: myEvent.id, completion: {
                self.getDataOffline()
                core.removePendingNotification(myEvent)
                Helper.showBasicAlert(title: "تم ✅", message: "تم حذف المناسبة بنجاح", buttonTitle: "موافق", isBlue: true, vc: self, completion: nil)
            })
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
