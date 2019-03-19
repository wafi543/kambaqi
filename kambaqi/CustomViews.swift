//
//  Core.swift
//  MyLectures
//
//  Created by Wafi Alshammari on 7/7/2018
//  Copyright © 2018 Wafi Alshammari. All rights reserved.
//

import Foundation
import UIKit

let sharedFunc = SharedFunctions()

class SharedFunctions {
    func radiusType (_ type : Int,_ height : CGFloat) -> CGFloat {
        var value : CGFloat = 0
        switch type {
        case 1: // Round 50%
            value = height / 2
        case 2: // Round 20%
            value = height / 5
        case 3: // Round 10%
            value = height / 10
        case 4: // Round 5%
            value = height / 20
        case 5: // Round 3.3%
            value = height / 30
        default:
            value = 0
        }
        return value
    }
}

public class ConfigureButton {
    let cornerRadius : CGFloat = 0
    let radiusType : Int = 2
    let Gradient: Bool = true
    let Color1: UIColor = scheme.c1
    let Color2: UIColor = scheme.c3
    let LocationX : Double = 2.0
    let LocationY : Double = 8.0
    let Direction : Int = 2
    let ColorTemplate : Int = 2
}

@IBDesignable class GradientView: UIView {
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    @IBInspectable var borderWidth : CGFloat = 0 {didSet{sharedInit()}}
    @IBInspectable var borderColor: UIColor = UIColor.clear {didSet{sharedInit()}}
    @IBInspectable var radiusType : Int = 2 { didSet {sharedInit()}}
    
    @IBInspectable var isShadowEnabled : Bool = false { didSet { sharedInit() }}
    @IBInspectable var cornerRadius : CGFloat = 0 { didSet { sharedInit() }}
    @IBInspectable var shadowColor : UIColor = UIColor.black { didSet { sharedInit() }}
    @IBInspectable var shadowOffset : CGSize = CGSize(width: 0, height: 0){ didSet { sharedInit() }}
    @IBInspectable var shadowRadius : CGFloat = 15 { didSet { sharedInit() }}
    @IBInspectable var shadowOpacity : Float = 0.5 { didSet { sharedInit() }}
    
    func sharedInit () {
        self.clipsToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = sharedFunc.radiusType(radiusType, frame.size.height)
        if isShadowEnabled {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = shadowOpacity
            self.layer.masksToBounds = false
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        }
    }
    
    @IBInspectable var Color1: UIColor = UIColor.clear
    @IBInspectable var Color2: UIColor = UIColor.clear
    @IBInspectable var Gradient: Bool = false {didSet{layoutSubviews()}}
    @IBInspectable var LocationX : Double = 0.0 {didSet{layoutSubviews()}}
    @IBInspectable var LocationY : Double = 1.0 {didSet{layoutSubviews()}}
    @IBInspectable var Direction : Int = 0 {didSet{layoutSubviews()}}
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [Color1.cgColor, Color2.cgColor]
        (layer as! CAGradientLayer).locations = [LocationX/10, LocationY/10] as [NSNumber]
//        (layer as! CAGradientLayer).endPoint = Vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0) // Vertical is Boolean
        
        switch Direction {
        case 1:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.0, y: 0.5)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 1.0, y: 0.5)
        case 2:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 1.0, y: 0.5)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.0, y: 0.5)
        case 3:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 0.0)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 1.0)
        case 4:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 1.0)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 0.0)
        case 5:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.0, y: 0.0)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 1.0, y: 1.0)
        case 6:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 1.0, y: 0.0)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.0, y: 1.0)
        case 7:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.0, y: 1.0)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 1.0, y: 0.0)
        default:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 1.0, y: 1.0)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.0, y: 0.0)
        }
    }
    
    func setAngle (angle : Double) {
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0*Double.pi*((x+0.75)/2.0))),2.0)
        let b = pow(sinf(Float(2*Double.pi*((x+0.0)/2))),2)
        let c = pow(sinf(Float(2*Double.pi*((x+0.25)/2))),2)
        let d = pow(sinf(Float(2*Double.pi*((x+0.5)/2))),2)
        (layer as! CAGradientLayer).startPoint = CGPoint(x: CGFloat(a), y: CGFloat(b))
        (layer as! CAGradientLayer).endPoint = CGPoint(x: CGFloat(c), y: CGFloat(d))
    }
    
}

@IBDesignable class ThreeColorsGradientView: UIView {
    @IBInspectable var FirstColor: UIColor = UIColor.red
    @IBInspectable var SecondColor: UIColor = UIColor.green
    @IBInspectable var ThirdColor: UIColor = UIColor.blue
    @IBInspectable var Vertical: Bool = true { didSet { updateGradientDirection() }}
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor, ThirdColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer }()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); applyGradient() }
    override init(frame: CGRect) { super.init(frame: frame);    applyGradient() }
    override func prepareForInterfaceBuilder() { super.prepareForInterfaceBuilder(); applyGradient() }
    override func layoutSubviews() { super.layoutSubviews(); updateGradientFrame() }
    func applyGradient() { updateGradientDirection(); layer.sublayers = [gradientLayer] }
    func updateGradientFrame() { gradientLayer.frame = bounds }
    func updateGradientDirection() { gradientLayer.endPoint = Vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0) }
}

@IBDesignable class RadialGradientView: UIView {
    @IBInspectable var outsideColor: UIColor = UIColor.red
    @IBInspectable var insideColor: UIColor = UIColor.green
    override func awakeFromNib() { super.awakeFromNib(); applyGradient() }
    
    func applyGradient() {
        let colors = [insideColor.cgColor, outsideColor.cgColor] as CFArray
        let endRadius = sqrt(pow(frame.width/2, 2) + pow(frame.height/2, 2))
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        let context = UIGraphicsGetCurrentContext()
        context?.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        #if TARGET_INTERFACE_BUILDER
        applyGradient()
        #endif
    }
}

@IBDesignable class CustomLabel: UILabel {
    @IBInspectable var isTextGradient : Bool = false {didSet{sharedInit()}}
    @IBInspectable var cornerRadius : CGFloat = 0
    @IBInspectable var borderWidth : CGFloat = 0
    @IBInspectable var borderColor: UIColor = UIColor(red: 34.0 / 255.0, green: 217.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); sharedInit() }
    override init(frame: CGRect) { super.init(frame: frame); sharedInit() }
    override func prepareForInterfaceBuilder() { sharedInit() }
    @IBInspectable var Direction : Int = 0
    @IBInspectable var Angle : Double = 0
    @IBInspectable var IsAngle : Bool = false
    
    func sharedInit() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
        if isTextGradient {
            updateGradientTextColor()
        }
    }
    
    private func updateGradientTextColor() {
        let size = CGSize(width: intrinsicContentSize.width, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let colors = Colors().gradientLabel
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),colors: colors as CFArray,locations: nil) else {return}
        
        var points = startEndFromDirection(direction: Direction, size: size)
        if IsAngle {points = startEndFromAngle(angle: Angle)}
        let start = points[0]
        let end = points[1]
        
        // Draw the gradient in image context
        context.drawLinearGradient(
            gradient,
            start: start,
            end: end, // Horizontal gradient
            options: []
        )
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            self.textColor = UIColor(patternImage: image)
        }
    }
    
    private func startEndFromAngle (angle : Double) -> [CGPoint] {
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0*Double.pi*((x+0.75)/2.0))),2.0)
        let b = pow(sinf(Float(2*Double.pi*((x+0.0)/2))),2)
        let c = pow(sinf(Float(2*Double.pi*((x+0.25)/2))),2)
        let d = pow(sinf(Float(2*Double.pi*((x+0.5)/2))),2)
        let start = CGPoint(x: CGFloat(a), y: CGFloat(b))
        let end = CGPoint(x: CGFloat(c), y: CGFloat(d))
        return [start,end]
    }
    
    private func startEndFromDirection (direction : Int, size : CGSize) -> [CGPoint] {
        var start = CGPoint.zero
        var end = CGPoint(x: size.width, y: 0)
        
        switch direction {
        case 1:
            start = CGPoint(x: 0.0, y: 0.5)
            end = CGPoint(x: 1.0, y: 0.5)
        case 2:
            start = CGPoint(x: 1.0, y: 0.5)
            end = CGPoint(x: 0.0, y: 0.5)
        case 3:
            start = CGPoint(x: 0.5, y: 0.0)
            end = CGPoint(x: 0.5, y: 1.0)
        case 4:
            start = CGPoint(x: 0.5, y: 1.0)
            end = CGPoint(x: 0.5, y: 0.0)
        case 5:
            start = CGPoint(x: 0.0, y: 0.0)
            end = CGPoint(x: 1.0, y: 1.0)
        case 6:
            start = CGPoint(x: 1.0, y: 0.0)
            end = CGPoint(x: 0.0, y: 1.0)
        case 7:
            start = CGPoint(x: 0.0, y: 1.0)
            end = CGPoint(x: 1.0, y: 0.0)
        case 8:
            start = CGPoint(x: 1.0, y: 1.0)
            end = CGPoint(x: 0.0, y: 0.0)
        default: break
        }
        return [start,end]
    }
}

@IBDesignable class CustomTextView: UITextView {
    @IBInspectable var cornerRadius : CGFloat = 0 { didSet { sharedInit() }}
    @IBInspectable var borderWidth : CGFloat = 0 { didSet { sharedInit() }}
    @IBInspectable var borderColor: UIColor = UIColor(red: 34.0 / 255.0, green: 217.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0) { didSet { sharedInit() }}
    
    func sharedInit() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
}

@IBDesignable class CustomText: UITextField {
    @IBInspectable var cornerRadius : CGFloat = 0 { didSet { sharedInit() }}
    @IBInspectable var borderWidth : CGFloat = 0 { didSet { sharedInit() }}
    @IBInspectable var borderColor: UIColor = UIColor(red: 34.0 / 255.0, green: 217.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0) { didSet { sharedInit() }}
    
    func sharedInit() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
}

@IBDesignable class CustomImage: UIImageView {
    @IBInspectable var cornerRadius : CGFloat = 0 {didSet { sharedInit()}}
    @IBInspectable var radiusType : Int  = 0 {didSet { sharedInit()}}
    @IBInspectable var borderWidth : CGFloat = 0 {didSet { sharedInit()}}
    @IBInspectable var borderColor: UIColor = UIColor(red: 34.0 / 255.0, green: 217.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); sharedInit() }
    override init(frame: CGRect) { super.init(frame: frame); sharedInit() }
    override func prepareForInterfaceBuilder() { sharedInit() }
    
    func sharedInit() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        clipsToBounds = true
        self.layer.cornerRadius = sharedFunc.radiusType(radiusType, frame.size.height)
    }
}

@IBDesignable class CustomButton: UIButton {
    let gradientLayer = CAGradientLayer()
    @IBInspectable var Color1: UIColor? {didSet {setGradient(Color1, Color2, Direction, LocationX, LocationY)}}
    @IBInspectable var Color2: UIColor? {didSet {setGradient(Color1, Color2, Direction, LocationX, LocationY)}}
    @IBInspectable var cornerRadius : CGFloat = 0 { didSet {sharedInit()}}
    @IBInspectable var Direction : Int = 2 {didSet{setGradient(Color1, Color2, Direction, LocationX, LocationY)}}
    @IBInspectable var LocationX : Double = 2 {didSet{setGradient(Color1, Color2, Direction, LocationX, LocationY)}}
    @IBInspectable var LocationY : Double = 8 {didSet{setGradient(Color1, Color2, Direction, LocationX, LocationY)}}
    @IBInspectable var isHighlightedEnabled : Bool = false
    
    @IBInspectable var isShadowEnabled : Bool = false {didSet{sharedInit()}}
    @IBInspectable var shadowColor : UIColor = UIColor.black {didSet{sharedInit()}}
    @IBInspectable var shadowOffset : CGSize = CGSize(width: 0, height: 0) {didSet{sharedInit()}}
    @IBInspectable var shadowRadius : CGFloat = 15 {didSet{sharedInit()}}
    @IBInspectable var shadowOpacity : Float = 0.5 {didSet{sharedInit()}}
    @IBInspectable var radiusType : Int = 2 {didSet{sharedInit()}}
    
    func sharedInit() {
        clipsToBounds = true
        self.layer.cornerRadius = sharedFunc.radiusType(radiusType, frame.size.height)
        if isShadowEnabled {
            self.clipsToBounds = true
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = shadowOpacity
            self.layer.masksToBounds = false
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        }
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            let touched = CALayer()
            touched.frame = bounds
            touched.backgroundColor = UIColor.black.cgColor
            touched.opacity = 0.3
            if isHighlighted && isHighlightedEnabled {
                if layer.sublayers?.last?.backgroundColor != UIColor.black.cgColor {
                    layer.addSublayer(touched)
                }
            }else {
                if layer.sublayers?.last?.backgroundColor == UIColor.black.cgColor {
                    layer.sublayers?.removeLast()
                }
            }
        }
    }
    
    private func setGradient(_ Color1: UIColor?, _ Color2: UIColor?, _ Direction : Int,_ LocationX : Double, _ LocationY : Double) {
        if let Color1 = Color1, let Color2 = Color2 {
            gradientLayer.frame = bounds
            gradientLayer.colors = [Color1.cgColor, Color2.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            
            gradientLayer.locations = [LocationX/10, LocationY/10] as [NSNumber]
            
            switch Direction {
            case 1:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            case 2:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            case 3:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            case 4:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            case 5:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            case 6:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            case 7:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            default:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
            }
            layer.insertSublayer(gradientLayer, at: 0)
            
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}

