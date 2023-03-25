//
//  UIButton+extensions.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 25.03.2023.
//

import UIKit

extension UIButton {

    convenience init(underlined text: String,
                     font: UIFont = UIFont(name: Fonts.Rubik.regular.rawValue, size: 16)!,
                     textColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1)) {
        self.init()
        setAttributedTitle(NSAttributedString(string: text,
                                                     attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]),
                           for: .normal)
        self.titleLabel?.font = font
        setTitleColor(textColor, for: .normal)
    }

}
