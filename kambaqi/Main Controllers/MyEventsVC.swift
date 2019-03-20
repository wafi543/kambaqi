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
        mainTableView.delegate = self; mainTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return 2}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventCell", for: indexPath) as! MyEventCell
        cell.edit.tag = indexPath.row
        cell.edit.addTarget(self, action: #selector(self.edit(sender:)), for: .touchUpInside)
        cell.delete.tag = indexPath.row
        cell.delete.addTarget(self, action: #selector(self.delete(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func edit(sender : UIButton) {
        
    }
    
    @objc func delete(sender : UIButton) {
        
    }
    
}
