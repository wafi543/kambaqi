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

class MyEventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var mainTableView: UITableView!
    
    var myEvents : [MyEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self; mainTableView.dataSource = self
        getDataOffline()
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
                let status = data.value(forKey: "status") as? Bool ?? false
                let myEvent = MyEvent.init(id: id, eventName: eventName, calendarType: calendarType, date: date, color: color, status: status)
                self.myEvents.append(myEvent)
            }
            DispatchQueue.main.async {self.mainTableView.reloadData(); ARSLineProgress.hide()}
        } catch {print("Failed")}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDataOffline()
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        vc.lastIndex = myEvents.count
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
        vc.lastIndex = myEvents.count
        vc.vcType = .EditVC
        vc.myEvent = myEvent
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func delete(sender : UIButton) {
        
    }
}
