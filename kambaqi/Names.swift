//
//  Names.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 19/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import Foundation
import UIKit

class Names {
    let mainTitles = ["حدث قريب","الأحداث","مناسباتي الخاصة","تاريخ اليوم","قد يهمك","إدارة الأحداث"]
    let mainIcons : [UIImage] = [UIImage(named: "soon-icon")!,UIImage(named: "events-icon")!,UIImage(named: "myEvents-icon")!,UIImage(named: "today-icon")!,UIImage(named: "alerts-icon")!,UIImage(named: "setting-icon")!]
    let colorNames = ["white","orange","cyan","yellow","green"]
    let socialTitles = ["انستقرام","سناب شات","تيليجرام","تويتر"]
    let socialIcons = ["insta-icon","snap-icon","telegram-icon","twitter-icon"]
    let settingTitles = ["شارك التطبيق","قيّم التطبيق","ترخيص الخصوصية"]
    let settingIcons = ["share-icon","rate-icon","privacy-icon"]
    let socialLinks = ["https://instagram.com/kam.baqi",
                       "https://snapchat.com/add/kambaqi",
                       "https://t.me/kambaqi",
                       "https://twitter.com/kambaqi"]
    let shareContent = ["أنصحك باستخدام تطبيق \" كم باقي \" \n \n \(core.AppURL)"]
}
