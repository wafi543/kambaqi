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
    @IBOutlet var Message: UILabel!
    
    var timer : Timer?
    var myEvent : MyEvent!
    var lineWidth : CGFloat = 3
    var radiusShape : CGFloat = 40
    var timeLeft: TimeInterval = 60
    let secondShapeLayer = CAShapeLayer()
    let minutesShapeLayer = CAShapeLayer()
    let hoursShapeLayer = CAShapeLayer()
    let daysShapeLayer = CAShapeLayer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
    }
    
    func configureShapesAndTimer () {
        // create my track
        let secondsPath = UIBezierPath(arcCenter: SecondView.center, radius: self.radiusShape, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        let minutesPath = UIBezierPath(arcCenter: MinuteView.center, radius: self.radiusShape, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        let hoursPath = UIBezierPath(arcCenter: HourView.center, radius: self.radiusShape, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        let daysPath = UIBezierPath(arcCenter: DayView.center, radius: self.radiusShape, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        func generateTrackLayer (_ path : UIBezierPath, _ strokeColor : UIColor, _ isDay : Bool) -> CAShapeLayer {
            let trackLayer = CAShapeLayer()
            trackLayer.path = path.cgPath
            trackLayer.strokeColor = strokeColor.cgColor
            trackLayer.lineWidth = self.lineWidth
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.lineCap = CAShapeLayerLineCap.round
            if isDay == false {trackLayer.opacity = 0.1}
            return trackLayer
        }
        SecondView.layer.addSublayer(generateTrackLayer(secondsPath, colors.secondColor, false))
        MinuteView.layer.addSublayer(generateTrackLayer(minutesPath, colors.minuteColor, false))
        HourView.layer.addSublayer(generateTrackLayer(hoursPath, colors.hourColor, false))
        DayView.layer.addSublayer(generateTrackLayer(daysPath, colors.dayColor, true))
        
        // create seconds progress
        secondShapeLayer.path = secondsPath.cgPath
        secondShapeLayer.strokeColor = colors.secondColor.cgColor
        secondShapeLayer.lineWidth = self.lineWidth
        secondShapeLayer.fillColor = UIColor.clear.cgColor
        secondShapeLayer.lineCap = CAShapeLayerLineCap.round
        secondShapeLayer.strokeStart = 0
        SecondView.layer.addSublayer(secondShapeLayer)
        
        // create minutes progress
        minutesShapeLayer.path = minutesPath.cgPath
        minutesShapeLayer.strokeColor = colors.minuteColor.cgColor
        minutesShapeLayer.lineWidth = self.lineWidth
        minutesShapeLayer.fillColor = UIColor.clear.cgColor
        minutesShapeLayer.lineCap = CAShapeLayerLineCap.round
        minutesShapeLayer.strokeStart = 0
        MinuteView.layer.addSublayer(minutesShapeLayer)
        
        // create hours progress
        hoursShapeLayer.path = hoursPath.cgPath
        hoursShapeLayer.strokeColor = colors.hourColor.cgColor
        hoursShapeLayer.lineWidth = self.lineWidth
        hoursShapeLayer.fillColor = UIColor.clear.cgColor
        hoursShapeLayer.lineCap = CAShapeLayerLineCap.round
        hoursShapeLayer.strokeStart = 0
        HourView.layer.addSublayer(hoursShapeLayer)
        
        updateTime()
        // define the future end time by adding the timeLeft to now Date()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timeLeft = myEvent.date.timeIntervalSinceNow
        if timeLeft > 0 {
            Message.isHidden = true
            SecondLabel.text = timeLeft.seconds
            MinuteLabel.text = timeLeft.minutes
            HourLabel.text = timeLeft.hours
            DayLabel.text = timeLeft.days
            
            secondShapeLayer.strokeEnd = CGFloat(timeLeft.seconds.floatValue / 74)
            minutesShapeLayer.strokeEnd = CGFloat(timeLeft.minutes.floatValue / 74)
            hoursShapeLayer.strokeEnd = CGFloat(timeLeft.hours.floatValue / 30)

            /*
            let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
            let second = timeLeft.seconds.doubleValue / 60
            strokeIt.fromValue = 0
            strokeIt.toValue = second
            strokeIt.duration = 0.1
            strokeIt.fillMode = .forwards
            strokeIt.isRemovedOnCompletion = false
            // add the animation to your timeLeftShapeLayer
            secondShapeLayer.add(strokeIt, forKey: nil)
             */
        } else {
            SecondLabel.text = "0"
            MinuteLabel.text = "0"
            HourLabel.text = "0"
            DayLabel.text = "0"
            Message.isHidden = false
        }
    }
    
}

class ColorCell: UICollectionViewCell {
    @IBOutlet var selectedView: GradientView!
}

class MenuCell: UITableViewCell {
    @IBOutlet var Icon: UIImageView!
    @IBOutlet var Title: UILabel!
    
}
