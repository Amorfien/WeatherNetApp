//
//  UILabel+extensions.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 26.03.2023.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont = UIFont(name: Fonts.Rubik.regular.rawValue, size: 16)!, textColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1), alignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
        self.numberOfLines = 2
        translatesAutoresizingMaskIntoConstraints = false
    }
    convenience init(ico: UIImage, value: String, font: UIFont, textColor: UIColor) {
        self.init()
        self.text = value
        self.font = font
        self.textColor = textColor

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = ico
        // Set bound to reposition
        let imageOffsetY: CGFloat = 5.0
//        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        imageAttachment.bounds = CGRect(x: 0, y: -imageOffsetY, width: font.pointSize + imageOffsetY / 2, height: font.pointSize + imageOffsetY / 2)
        // Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        completeText.append(attachmentString)
        // Add your text to mutable string
        let textAfterIcon = NSAttributedString(string: " \(value)")
        completeText.append(textAfterIcon)
        textAlignment = .center
        attributedText = completeText
    }
}
