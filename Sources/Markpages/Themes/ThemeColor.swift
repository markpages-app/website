//
//  File.swift
//  
//
//  Created by amine on 07/04/2024.
//

import Foundation

struct ThemeColor {
    let primaryColor: String

    init(primaryColor: String = "#f17c37") {
        self.primaryColor = primaryColor
    }

    static let light = ThemeColor()
    static let dark = ThemeColor(primaryColor: "#a04f1c")
}
