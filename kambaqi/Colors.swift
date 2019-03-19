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
}

class Scheme1 {
    let c1 = helper.hexStringToUIColor(hex: "1B7152")
    let c2 = helper.hexStringToUIColor(hex: "ffffff")
    let c3 = helper.hexStringToUIColor(hex: "ffffff")
    let c4 = helper.hexStringToUIColor(hex: "ffffff")
    let c5 = helper.hexStringToUIColor(hex: "ffffff")
    let c6 = helper.hexStringToUIColor(hex: "ffffff")
}

