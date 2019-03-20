//
//  Helper.swift
//  Weddings
//
//  Created by Wafi Alshammari on 24/7/2018.
//  Copyright © 2018 Wafi AlShammari. All rights reserved.
//

import Foundation
import UIKit
import ARSLineProgress
import SDWebImage
import Alamofire
import CoreData
import Toast_Swift

class FireBaseErrors {
    let UserNotFound : String = "Optional(Error Domain=FIRAuthErrorDomain Code=17011 \"There is no user record corresponding to this identifier. The user may have been deleted.\" UserInfo={NSLocalizedDescription=There is no user record corresponding to this identifier. The user may have been deleted., error_name=ERROR_USER_NOT_FOUND})"
    let InvalidPassword : String = "Optional(Error Domain=FIRAuthErrorDomain Code=17009 \"The password is invalid or the user does not have a password.\" UserInfo={NSLocalizedDescription=The password is invalid or the user does not have a password., error_name=ERROR_WRONG_PASSWORD})"
    let EmailInUse : String = "Optional(Error Domain=FIRAuthErrorDomain Code=17007 \"The email address is already in use by another account.\" UserInfo={NSLocalizedDescription=The email address is already in use by another account., error_name=ERROR_EMAIL_ALREADY_IN_USE})"
    let MinimumPassword : String = "Optional(Error Domain=FIRAuthErrorDomain Code=17026 \"The password must be 6 characters long or more.\" UserInfo={error_name=ERROR_WEAK_PASSWORD, NSLocalizedFailureReason=Password should be at least 6 characters, NSLocalizedDescription=The password must be 6 characters long or more.})"
    let InvalidCode : String = "Optional(Error Domain=FIRAuthErrorDomain Code=17044 \"The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user.\" UserInfo={NSLocalizedDescription=The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user., error_name=ERROR_INVALID_VERIFICATION_CODE})"
    let ExpiredCode : String = "Optional(Error Domain=FIRAuthErrorDomain Code=17051 \"The SMS code has expired. Please re-send the verification code to try again.\" UserInfo={NSLocalizedDescription=The SMS code has expired. Please re-send the verification code to try again., error_name=ERROR_SESSION_EXPIRED})"
    let TOO_MANY_REQUESTS : String = "Optional(Error Domain=FIRAuthErrorDomain Code=17010 \"We have blocked all requests from this device due to unusual activity. Try again later.\" UserInfo={NSLocalizedDescription=We have blocked all requests from this device due to unusual activity. Try again later., error_name=ERROR_TOO_MANY_REQUESTS})"
}

public class Helper {
    
    func AppVerion (Status : Bool) -> String {
        var temp1 = "Error App version "
        var temp2 = "Error build version"
        var Content = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String { temp1 = version }
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String { temp2 = "\(build)" }
        if (Status == true) {Content = temp1} else {Content = temp2}
        return Content
    }
    
    func customFormatter (_ format : String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
    
    public static func showBasicAlert(title: String?, message: String?, buttonTitle: String?, isBlue: Bool, vc: UIViewController, completion: (() -> ())?) {
        var style = UIAlertAction.Style.default; if isBlue == false {style = UIAlertAction.Style.destructive}
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: style) { (action) in if completion != nil {completion!()}}
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
    
    public static func showErrorMessage (_ error : Error? ,_ line:Int, _ vc : UIViewController) {
        ARSLineProgress.showFail()
        if isConnectedToInternet {
            print(error.debugDescription)
            let errors = FireBaseErrors()
            if error.debugDescription == errors.UserNotFound {
                showBasicAlert(title: "Email Not Found ❌", message: "خطأ، الحساب غير موجود", buttonTitle: "موافق", isBlue: false, vc: vc, completion: nil)
            }else if error.debugDescription == errors.InvalidPassword {
                showBasicAlert(title: "Invalid Password ❌", message: "خطأ في كلمة السر، هل نسيت كلمة السر؟", buttonTitle: "موافق", isBlue: false, vc: vc, completion: nil)
            }else if error.debugDescription == errors.EmailInUse {
                showBasicAlert(title: "Email is used ❌", message: "الايميل مستخدم مسبقاً", buttonTitle: "موافق", isBlue: false, vc: vc, completion: nil)
            }else if error.debugDescription == errors.MinimumPassword {
                showBasicAlert(title: "Password not correct ❌", message: "Password should be at least 6 characters", buttonTitle: "OK", isBlue: false, vc: vc, completion: nil)
            }else if error.debugDescription == errors.InvalidCode {
                showBasicAlert(title: "خطأ في المصادقة ❌", message: "رقم الكود الذي أدخلته غير صحيح", buttonTitle: "موافق", isBlue: false, vc: vc, completion: nil)
            }else if error.debugDescription == errors.ExpiredCode {
                showBasicAlert(title: "خطأ في المصادقة ❌", message: "انتهت صلاحية الكود الذي أدخلته", buttonTitle: "موافق", isBlue: false, vc: vc, completion: nil)
            }else if error.debugDescription == errors.TOO_MANY_REQUESTS {
                showBasicAlert(title: "TOO_MANY_REQUESTS ❌", message: "تم حظر رقمك بسبب الطلبات الكثيرة والغير عادية، حاول في وقت لاحق", buttonTitle: "موافق", isBlue: false, vc: vc, completion: nil)
            }
            else {
                showBasicAlert(title: "Error❌. VC:\(vc.description) Line:\(line) ", message: "\(String(describing: error))", buttonTitle: "OK", isBlue: false, vc: vc, completion: nil)
            }
            
        }else {
            Helper.showBasicAlert(title: "Connection Error ❌", message: "أنت غير متصل بالانترنت", buttonTitle: "OK", isBlue: false, vc: vc, completion: nil)
        }
    }
    
    class var isConnectedToInternet : Bool { return NetworkReachabilityManager()!.isReachable }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {cString.remove(at: cString.startIndex)}
        if ((cString.count) != 6) {return UIColor.gray}
        var rgbValue:UInt32 = 0;
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func resizeImageWith(image: UIImage, newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / image.size.width
        let verticalRatio = newSize.height / image.size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        var newImage: UIImage
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = false
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    
    @available(iOS 10.0, *)
    func DeleteFromCoreData(_ entityName : String) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}

// Extensions

extension UIImageView {
    func loadImageUsingCache (_ urlString : String,_ defaultImage : UIImage? ,_ completion: ((UIImage?) -> ())?) {
        let size : CGFloat = 50
        let indicator = UIActivityIndicatorView()
        indicator.clipsToBounds = true
        indicator.hidesWhenStopped = true
        indicator.layer.backgroundColor = UIColor.black.cgColor
        indicator.layer.opacity = 0.4
        indicator.layer.cornerRadius = 10
        indicator.style = .whiteLarge
        let position = (bounds.size.width / 2) - (size / 2)
        indicator.frame = CGRect.init(x: position, y: position, width: size, height: size)
        indicator.startAnimating()
        self.addSubview(indicator)
        if urlString == "" {
            self.image = defaultImage
            self.subviews.last?.removeFromSuperview()
            completion?(self.image)
        }else {
            // Download with cache From: Pod 'SDWebImage'
            self.sd_setImage(with: URL(string: urlString)) { (uiimage, error, sdImageCacheType, imageUrl) in
                self.subviews.last?.removeFromSuperview()
                completion?(uiimage)
            }
        }
    }
    
    func makeImageTapped () {
        
    }
}

public extension UITextField {
    @objc func dismissKeyboard(thisView: UIView) {self.endEditing(true)}
    
    public func addUnderlineDesign(borderColor: UIColor,borderWidth: CGFloat,masksToBounds: Bool) {
        
        let border = CALayer()
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = masksToBounds
    }
    
    func setToolBar(_ doneTitle: String) {
        var title = doneTitle; if title == "" {title = "Done"}
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: title, style: .done, target: nil, action: #selector(self.dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, done], animated: false)
        self.inputAccessoryView = toolbar
    }
    
}

public extension UITextView {
    @objc func dismissKeyboard(thisView: UIView) {self.endEditing(true)}
    
    func setToolBar(_ doneTitle: String){
        var title = doneTitle; if title == "" {title = "Done"}
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: title, style: .done, target: nil, action: #selector(self.dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, done], animated: false)
        self.inputAccessoryView = toolbar
    }
    
}

public extension UIButton {
    public func roundedButton(){ self.layer.cornerRadius = self.frame.height / 2; self.clipsToBounds = true }
    
    public func applyButtonDesign(title: String = "Button",
                                  titleColor: UIColor = .white,
                                  cornerRadius: CGFloat = 0.0,
                                  backgroundColor: UIColor = .blue,
                                  shadowColor: UIColor = .black,
                                  shadowRadius: CGFloat = 0.0,
                                  shadowOpacity: Float = 0.0) {
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.layer.backgroundColor = backgroundColor.cgColor
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

public extension String {
    
    /**
     Return true if the string matched an email format like "abdullah@alhaider.net" .
     *How to use :*
     Declare a variable or constant like ==> let email = "abc@efg.com".isValidEmail
     *Values :*
     `emailFormat` Passing a regulare expression string "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}".
     `emailPredicate` NSPredicate.
     - important: Regular expression is case sensitive.
     - returns: true.
     - Author: Abdullah Alhaider
     */
    public var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // This is a regular expression
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    /* -------------------------------------------------------------------------------- */
    
    /**
     Return true if the string has only numbers "0123456789".
     *How to use :*
     Declare a variable or constant like ==> let number = "12345".isValidNumber
     *Values*
     `numberFormat` : Numbers regulare expression string "^[0-9]*$".
     `numberPredicate` : NSPredicate(format:"SELF MATCHES %@", numberFormat).
     - important: Regular expression is case sensitive.
     - returns: true.
     - Author:
     Abdullah Alhaider
     */
    
    public var isValidNumber: Bool {
        let numberFormat = "^[0-9]*$"
        let numberPredicate = NSPredicate(format:"SELF MATCHES %@", numberFormat)
        return numberPredicate.evaluate(with: self)
    }
    
    public var isValidPhone: Bool {
        let phoneFormat = "^[+][1-9]{1,4}[0-9]{4,25}" // This is a regular expression
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneFormat)
        return phonePredicate.evaluate(with: self)
    }
    
    
    /* -------------------------------------------------------------------------------- */
    
    
    /**
     Return true if the string has minimum 8 characters, and at least one uppercase letter, and one lowercase letter and one number
     , You can see more on http://regexlib.com/Search.aspx?k=password
     *How to use :*
     Declare a variable or constant like ==> let password = "Gg123456".isValidPassword
     *Values*
     `passwordFormat` : Password regulare expression string "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$".
     `passwordPredicate` : NSPredicate(format:"SELF MATCHES %@", passwordFormat).
     - important: Regular expression is case sensitive.
     - returns: true.
     - Author: Abdullah Alhaider
     */
    
    public var isValidPassword: Bool {
        let passwordFormat = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: self)
    }
    
    /* -------------------------------------------------------------------------------- */
    /* -------------------------------------------------------------------------------- */
    /* -------------------------------------------------------------------------------- */
    
    
    /**
     Return true if the string is a valid url.
     *How to use :*
     Declare a variable or constant like ==> let url = "https://google.com".isValidUrl
     - returns: true.
     - Author: Abdullah Alhaider
     */
    
    public var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    
    
    /* -------------------------------------------------------------------------------- */
    /* -------------------------------------------------------------------------------- */
    /* -------------------------------------------------------------------------------- */
    
    
    /**
     Replacing string with another string "aaa" => "ttt".
     *How to use :*
     replace(string: " ", replacement: "")
     *Values*
     `numberFormat` string.
     `numberPredicate` replacement.
     - returns: String .
     - Author: Abdullah Alhaider.
     */
    
    public func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    
    /* -------------------------------------------------------------------------------- */
    
    /**
     Removing the white space in any string by calling removeWhitespace() after a string value.
     *How to use :*
     Declare a variable or constant like ==> let text = "H e l l o   W o r l d !".removeWhitespace()
     - returns: String with no white space in.
     - Author: Abdullah Alhaider.
     */
    
    public func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    /* -------------------------------------------------------------------------------- */
    
    /**
     Replacing string by another string .
     - returns: String.
     - Author: Abdullah Alhaider.
     */
    
    public func replaceString(existingString: String, replaceItWith: String ) -> String {
        return self.replace(string: existingString, replacement: replaceItWith)
    }
    
}

public extension UIView {
    
    /**
     Adds a vertical gradient layer with two **UIColors** to the **UIView**.
     - Parameter topColor: The top **UIColor**.
     - Parameter bottomColor: The bottom **UIColor**.
     */
    
    public func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    // To use it in you viewDidLoad() -->> view.addVerticalGradientLayer(topColor: UIColor.black, bottomColor: UIColor.red)
    
    public func applyViewDesign(masksToBounds: Bool = false,
                                shadowColor: UIColor = .black,
                                cornerRadius: CGFloat = 0.0,
                                shadowOpacity: Float = 0.0,
                                shadowOffset: CGSize = CGSize(width: 0, height: 0),
                                shadowRadius: CGFloat = 0.0) {
        
        self.layer.masksToBounds = masksToBounds
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = cornerRadius
        //self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = false
        //self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        if nanoseconds(from: date) > 0 { return "\(nanoseconds(from: date))ns" }
        return ""
    }
    
    func getDayName (identifier : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: identifier)
        let dayInWeek = dateFormatter.string(from: self)
        return dayInWeek
    }
    
    func toString (_ formatterStr : String, _ identifier : String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: identifier)
        formatter.dateFormat = formatterStr
        return formatter.string(from: self)
    }
    
    mutating func addDaysComponent (_ days : Int) {
        var component = DateComponents()
        component.day = days
        self = Calendar.current.date(byAdding: component, to: self)!
    }
    
}

extension UIView {
    func addDiamondMask(cornerRadius: CGFloat = 0) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.minY + cornerRadius))
        path.addLine(to: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY - cornerRadius))
        path.addLine(to: CGPoint(x: bounds.minX + cornerRadius, y: bounds.midY))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = cornerRadius * 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        layer.mask = shapeLayer
    }
}

extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

extension NSRegularExpression { // This is for Regular expression
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

extension String { // This is for Regular expression
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
    var intValue: Int {
        return (self as NSString).integerValue
    }
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    func toDate (_ formatterStr : String, _ identifier : String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: identifier)
        formatter.dateFormat = formatterStr
        return formatter.date(from: self)
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

extension Bool {
    func getReverse() -> Bool{
        if self == true {
            return false
        } else {
            return true
        }
    }
}

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         textAlignment:NSTextAlignment = NSTextAlignment.center,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showTwoActions(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "OK",
                         cancelTitle:String? = "Cancel",
                         actionStyle:UIAlertAction.Style = .default,
                         cancelStyle:UIAlertAction.Style = .cancel,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: actionHandler))
        alert.addAction(UIAlertAction(title: cancelTitle, style: cancelStyle, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToast(_ message:String){
        var style = ToastStyle()
        style.backgroundColor = .black
        style.messageColor = .white
//        style.messageFont = UIFont(name: "System", size: 18)
        self.view.makeToast(message, duration: 2.0, position: .center, style: style)
    }
}

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
    var seconds: String {
        return String(format:"%02d", Int(ceil(truncatingRemainder(dividingBy: 60))))
    }
}
