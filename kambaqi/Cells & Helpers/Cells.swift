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
    @IBOutlet var View: GradientView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var EventName: UILabel!
    @IBOutlet var DayView: UIView!
    @IBOutlet var HourView: UIView!
    @IBOutlet var MinuteView: UIView!
    @IBOutlet var SecondView: UIView!
    @IBOutlet var DayLabel: UILabel!
    @IBOutlet var HourLabel: UILabel!
    @IBOutlet var MinuteLabel: UILabel!
    @IBOutlet var SecondLabel: UILabel!
    
    var timer : Timer?
    var myEvent : MyEvent?
    
    var lineWidth : CGFloat = 3
    var radiusShape : CGFloat = 40
    var timeLeft: TimeInterval = 60
    var endTime: Date?
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    let secondShapeLayer = CAShapeLayer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
    }
    
    func configureShapesAndTimer () {
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = timeLeft
        
        let center = SecondView.center
        // create my track
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: self.radiusShape, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        secondShapeLayer.path = circularPath.cgPath
        secondShapeLayer.strokeColor = colors.secondColor2.cgColor
        secondShapeLayer.lineWidth = self.lineWidth
        secondShapeLayer.fillColor = UIColor.clear.cgColor
        secondShapeLayer.lineCap = CAShapeLayerLineCap.round
        SecondView.layer.addSublayer(trackLayer)
        // create progress
        secondShapeLayer.path = circularPath.cgPath
        secondShapeLayer.strokeColor = colors.secondColor1.cgColor
        secondShapeLayer.lineWidth = self.lineWidth
        secondShapeLayer.fillColor = UIColor.clear.cgColor
        secondShapeLayer.lineCap = CAShapeLayerLineCap.round
        
        SecondView.layer.addSublayer(secondShapeLayer)
        
        secondShapeLayer.strokeStart = 0
        secondShapeLayer.strokeEnd = 5
        
        // add the animation to your timeLeftShapeLayer
//        secondShapeLayer.add(strokeIt, forKey: nil)
        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft)
        print(endTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            SecondLabel.text = timeLeft.time
        } else {
            SecondLabel.text = "0"
            timer?.invalidate()
        }
    }
    
}

class ColorCell: UICollectionViewCell {
    @IBOutlet var selectedView: GradientView!
}
