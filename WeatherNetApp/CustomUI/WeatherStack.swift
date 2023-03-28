//
//  WeatherStack.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 28.03.2023.
//

import UIKit

final class WeatherStack: UIStackView {

    enum WeatherStack: String {
        case temp = "По ощущениям"
        case wind = "Ветер"
        case ultraviolet = "УФ индекс"
        case rainfall = "Дождь"
        case cloud = "Облачность"
    }


    var icoLabel = UILabel()
    var valueLabel = UILabel()

    init(title: WeatherStack, value: String, separator: Bool) {
        super.init(frame: .zero)

        var imageName = ""
        switch title {
        case .temp: imageName = "colorMoon"
        case .wind: imageName = "colorWind"
        case .ultraviolet: imageName = "colorSun"
        case .rainfall: imageName = "colorRaindrops"
        case .cloud: imageName = "colorCloudy"
        }

        icoLabel = UILabel(ico: UIImage(named: imageName)!, value: title.rawValue, font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)!, textColor: #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1))
        valueLabel = UILabel(text: value, font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 18)!, textColor: #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1), alignment: .right)

        let elements = [icoLabel, valueLabel]
        addArrangedSubviews(to: self, elements: elements)
        setupConstraints()

        if separator {
            addBottomBorder()
        }


    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

        ])
    }

    func addBottomBorder() {
       let thickness: CGFloat = 0.5
       let bottomBorder = CALayer()
       bottomBorder.frame = CGRect(x: -16, y: 45, width: UIScreen.main.bounds.width - 32, height: thickness)
       bottomBorder.backgroundColor = UIColor.lightGray.cgColor
       self.layer.addSublayer(bottomBorder)
    }


}
