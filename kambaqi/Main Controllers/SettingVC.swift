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

class SettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var mainTableView: UITableView!
    
    var events : [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self; mainTableView.dataSource = self
        getDataOffline()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
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
    
}
