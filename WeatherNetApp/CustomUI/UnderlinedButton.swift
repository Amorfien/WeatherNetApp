//
//  UnderlinedButton.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 27.03.2023.
//

import UIKit

final class UnderlinedButton: UIButton {

    private var buttonAction: () -> Void

    init(underlined text: String,
         font: UIFont = UIFont(name: Fonts.Rubik.regular.rawValue, size: 16)!,
         textColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1), action: @escaping () -> Void) {
        self.buttonAction = action
        super.init(frame: .zero)

        setAttributedTitle(NSAttributedString(string: text,
                                                     attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]),
                           for: .normal)
        self.titleLabel?.font = font
        setTitleColor(textColor, for: .normal)

        
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonDidTap() {

        buttonAction()
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        let myNormalAtributedTitle = NSAttributedString(string: title ?? "", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        self.setAttributedTitle(myNormalAtributedTitle, for: state)
    }

}
