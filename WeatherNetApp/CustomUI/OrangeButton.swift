//
//  OrangeButton.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

final class OrangeButton: UIButton {

    private var buttonAction: () -> Void

    init(title: String, font: UIFont, action: @escaping () -> Void) {
        self.buttonAction = action
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = font
        backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.431372549, blue: 0.06666666667, alpha: 1)

        titleLabel?.adjustsFontSizeToFitWidth = true
        layer.cornerRadius = 10
        addTarget(self, action: #selector(changeState), for: .touchDown)
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func changeState() {
        backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.337254902, blue: 0.02745098039, alpha: 1)
    }
    @objc private func buttonDidTap() {
        backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.431372549, blue: 0.06666666667, alpha: 1)
        layer.shadowColor = #colorLiteral(red: 0.9490196078, green: 0.431372549, blue: 0.06666666667, alpha: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 45
        layer.shadowOffset = CGSize(width: -5, height: 5)
        buttonAction()
    }

}
