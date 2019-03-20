//
//  Cells.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 19/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {
    @IBOutlet var Icon: UIImageView!
    @IBOutlet var Title: UILabel!
    
}

class EventCell: UITableViewCell {
    @IBOutlet var Name: UILabel!
    @IBOutlet var Days: UILabel!
    @IBOutlet var EventType: UILabel!
    @IBOutlet var OneTime: UILabel!
}

class AdCell: UITableViewCell {
    @IBOutlet var Photo: UIImageView!
}

class SettingCell: UITableViewCell {
    @IBOutlet var toggle: UIButton!
    @IBOutlet var EventName: CustomLabel!
    
}

class MyEventCell: UITableViewCell {
    @IBOutlet var edit: UIButton!
    @IBOutlet var delete: UIButton!
    @IBOutlet var Name: UILabel!
    @IBOutlet var DayView: UIView!
    @IBOutlet var HourView: UIView!
    @IBOutlet var MinuteView: UIView!
    @IBOutlet var SecondView: UIView!
    
}
