//
//  SimpleButton.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 27.03.2023.
//

import UIKit

final class SimpleButton: UIButton {

    private var buttonAction: () -> Void

    init(title: String, font: UIFont, action: @escaping () -> Void) {
        self.buttonAction = action
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = font
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    init(image: UIImage, action: @escaping () -> Void) {
        self.buttonAction = action
        super.init(frame: .zero)
        setImage(image, for: .normal)

        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonDidTap() {
        buttonAction()
    }

}
