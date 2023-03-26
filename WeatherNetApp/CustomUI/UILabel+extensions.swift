//
//  UILabel+extensions.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 26.03.2023.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont = UIFont(name: Fonts.Rubik.regular.rawValue, size: 16)!, textColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1), center: Bool = false) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        if center { self.textAlignment = .center }
        translatesAutoresizingMaskIntoConstraints = false
    }
}
