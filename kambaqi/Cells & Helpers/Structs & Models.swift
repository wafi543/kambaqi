//
//  Structs & Models.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 19/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import Foundation
import Firebase

struct Event {
    var id: String
    var calendarType: Int
    var eventInterval: Int
    var eventName: String
    var date : Date
}

struct MyEvent {
    var id : String
    var eventName : String
    var calendarType : String
    var date : Date
    var color : EventColor
    var status : Bool
}

struct Photo {
    var id: String
    var mUri: String
    var mName : String
}

enum EventColor : String {
    case Default
    case Orange
    case Cyan
    case Yellow
    case Green
}

enum DateType : String {
    case None
    case Monthly
    case Annual
}
