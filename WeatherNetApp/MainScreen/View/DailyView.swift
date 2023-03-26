//
//  DailyView.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

final class DailyView: UIView {

    let sunLayer: CAShapeLayer = {
        let layer = CAShapeLayer()

        let sunFrame = UIScreen.main.bounds.width - (16 + 33) * 2
        let radius = sunFrame / 2
//        let screenCenter = UIScreen.main.bounds.width / 2
        let center = CGPoint(x: radius + 32, y: radius + 17)
        let startAngle = -CGFloat.pi// * 0.95
        let endAngle = -CGFloat.pi * 0.0

        let sunPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        layer.path = sunPath.cgPath
        layer.strokeColor = #colorLiteral(red: 0.9647058824, green: 0.8666666667, blue: 0.003921568627, alpha: 1).cgColor
        layer.lineWidth = 3
        layer.fillColor = UIColor.clear.cgColor

        layer.transform = CATransform3DMakeScale(1, 0.8, 1)
        return layer
    }()

    let curendDateLabel = UILabel(text: "17:48, пт 16 апреля", textColor: #colorLiteral(red: 0.9647058824, green: 0.8666666667, blue: 0.003921568627, alpha: 1), center: true)
    let weatherLabel = UILabel(text: "Возможен небольшой дождь", textColor: .white, center: true)
    let tempLabel = UILabel(text: " 13°", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 36)!, textColor: .white, center: true)
    let rangeTempLabel = UILabel(text: " 7°/13°", textColor: .white, center: true)
    let sunriseIco = UIImageView(image: UIImage(named: "sunrise_yellow"))
    let sunsetIco = UIImageView(image: UIImage(named: "sunset_yellow"))


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        layer.cornerRadius = 5


        layer.addSublayer(sunLayer)
        addSubviews(view: self, elements: [curendDateLabel, weatherLabel, tempLabel, rangeTempLabel, sunriseIco, sunsetIco])
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            curendDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            curendDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            curendDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            weatherLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 6),
            weatherLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempLabel.bottomAnchor.constraint(equalTo: weatherLabel.topAnchor, constant: -5),
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            rangeTempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            rangeTempLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -5),
            rangeTempLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            sunriseIco.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sunriseIco.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),

            sunsetIco.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            sunsetIco.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
        ])
    }

}
