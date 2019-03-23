//
//  MenuVC.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 21/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var socialTableView: UITableView!
    @IBOutlet var settingTableView: UITableView!
    @IBOutlet var privacyTableView: UITableView!
    @IBOutlet var Version: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socialTableView.delegate = self; socialTableView.dataSource = self
        settingTableView.delegate = self; settingTableView.dataSource = self
        privacyTableView.delegate = self; privacyTableView.dataSource = self
        Version.text = "Version: \(helper.AppVerion(Status: true)).\(helper.AppVerion(Status: false))"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == socialTableView {
            return names.socialTitles.count
        }else if tableView == settingTableView {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        if tableView == socialTableView {
            cell.Icon.image = UIImage(named: names.socialIcons[indexPath.row])
            cell.Title.text = names.socialTitles[indexPath.row]
        }else if tableView == settingTableView {
            cell.Icon.image = UIImage(named: names.settingIcons[indexPath.row])
            cell.Title.text = names.settingTitles[indexPath.row]
        }else {
            cell.Icon.image = UIImage(named: "privacy-icon")
            cell.Title.text = "ترخيص الخصوصية"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView == socialTableView {
            guard let url = URL(string: names.socialLinks[indexPath.row]) else {self.showToast("خطأ. MenuVC#\(#line)"); return}
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else if tableView == settingTableView {
            if indexPath.row == 0 {
                let activityViewController = UIActivityViewController(activityItems: names.shareContent , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }else {
                guard let url = URL(string: core.AppURL) else {self.showToast("خطأ. MenuVC#\(#line)"); return}
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else {
            guard let url = URL(string: "https://cymbiform-welds.000webhostapp.com/index.html") else {self.showToast("خطأ. MenuVC#\(#line)"); return}
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
