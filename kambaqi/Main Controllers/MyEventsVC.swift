//
//  MyEventsVC.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 20/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit

class MyEventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var mainTableView: UITableView!
    
    var myEvents : [MyEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return myEvents.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        
        let event = myEvents[indexPath.row]
        cell.toggle.tag = indexPath.row
        cell.toggle.addTarget(self, action: #selector(self.eventToggle(sender:)), for: .touchUpInside)
        cell.EventName.text = event.eventName
        
        return cell
    }
    
    @objc func eventToggle (sender : UIButton) {
        
    }
    
}
