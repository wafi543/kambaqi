//
//  Colors.swift
//  Weddings
//
//  Created by Wafi Alshammari on 28/7/2018.
//  Copyright © 2018 Wafi AlShammari. All rights reserved.
//

import Foundation

let scheme = Scheme1()
let colors = Colors()

class Colors {
    let gradientLabel = [scheme.c2.cgColor,scheme.c3.cgColor,scheme.c4.cgColor,scheme.c3.cgColor,scheme.c2.cgColor]
    let dayColor = helper.hexStringToUIColor(hex: "4d4d4d")
    let hourColor1 = helper.hexStringToUIColor(hex: "8cdcda")
    let hourColor2 = helper.hexStringToUIColor(hex: "e7f7f7")
    let minuteColor1 = helper.hexStringToUIColor(hex: "b1d877")
    let minuteColor2 = helper.hexStringToUIColor(hex: "eef6e3")
    let secondColor1 = helper.hexStringToUIColor(hex: "f16a70")
    let secondColor2 = helper.hexStringToUIColor(hex: "fbe0e1")
}

class Scheme1 {
    let c1 = helper.hexStringToUIColor(hex: "1B7152")
    let c2 = helper.hexStringToUIColor(hex: "ffffff")
    let c3 = helper.hexStringToUIColor(hex: "ffffff")
    let c4 = helper.hexStringToUIColor(hex: "ffffff")
    let c5 = helper.hexStringToUIColor(hex: "ffffff")
    let c6 = helper.hexStringToUIColor(hex: "ffffff")
}

