//
//  TodayVC.swift
//  Kambaqi
//
//  Created by Wafi Alshammari on 19/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit

class TodayVC: UIViewController {
    @IBOutlet var DayName: UILabel!
    @IBOutlet var Gregorian: UILabel!
    @IBOutlet var Hijri: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        DayName.text = date.getDayName(identifier: "ar")
        Gregorian.text = date.toString(dateFormatterStr, "ar")
        Hijri.text = date.toString(dateFormatterStr, "ar_SA")
    }
    
}
