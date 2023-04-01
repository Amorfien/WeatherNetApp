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
        let center = CGPoint(x: radius + 32, y: radius + 20)
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

    var sum1Label = UILabel(ico: UIImage(named: "colorSunCloud")!, value: "0", font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)!, textColor: .white)
    var sum2Label = UILabel(ico: UIImage(named: "colorWind")!, value: "3 м/с", font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)!, textColor: .white)
    var sum3Label = UILabel(ico: UIImage(named: "colorRaindrops")!, value: "75%", font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)!, textColor: .white)
    private lazy var summaryStack = UIStackView(arrangedSubviews: [sum1Label, sum2Label, sum3Label])

    let curentDateLabel = UILabel(text: "17:48, пт 16 апреля", textColor: #colorLiteral(red: 0.9647058824, green: 0.8666666667, blue: 0.003921568627, alpha: 1), alignment: .center)
    let weatherLabel = UILabel(text: "Возможен небольшой дождь", textColor: .white, alignment: .center)
    let tempLabel = UILabel(text: " 13°", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 36)!, textColor: .white, alignment: .center)
    let rangeTempLabel = UILabel(text: " 7°/13°", textColor: .white, alignment: .center)
    let sunriseIco = UIImageView(image: UIImage(named: "sunrise_yellow"))
    let sunsetIco = UIImageView(image: UIImage(named: "sunset_yellow"))
    let sunriseLabel = UILabel(text: "05:41", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 14)!, textColor: .white)
    let sunsetLabel = UILabel(text: "19:31", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 14)!, textColor: .white)


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        layer.cornerRadius = 5

        summaryStack.distribution = .fillEqually
        summaryStack.spacing = 19


        layer.addSublayer(sunLayer)
        addSubviews(to: self, elements: [curentDateLabel, summaryStack, weatherLabel, tempLabel, rangeTempLabel,
                                         sunriseIco, sunsetIco, sunriseLabel, sunsetLabel])
        setupConstraints()
        dateFormat()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            curentDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            curentDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            curentDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            summaryStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            summaryStack.bottomAnchor.constraint(equalTo: curentDateLabel.topAnchor, constant: -10),
            summaryStack.heightAnchor.constraint(equalToConstant: 30),
//            summaryStack.widthAnchor.constraint(equalToConstant: 188),

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

            sunriseLabel.centerXAnchor.constraint(equalTo: sunriseIco.centerXAnchor),
            sunriseLabel.topAnchor.constraint(equalTo: sunriseIco.bottomAnchor, constant: 5),

            sunsetLabel.centerXAnchor.constraint(equalTo: sunsetIco.centerXAnchor),
            sunsetLabel.topAnchor.constraint(equalTo: sunsetIco.bottomAnchor, constant: 5),

        ])
    }

    private func dateFormat() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm, E d MMM"
        let text = formatter.string(from: date)
        curentDateLabel.text = text
    }

    func fillView(currentWeather: CurrentWeatherData?) {
        guard let currentWeather else { return }
        tempLabel.text = "\(Int(currentWeather.main?.temp?.rounded() ?? 0))°"
        weatherLabel.text = currentWeather.weather?[0].description?.capitalized
        rangeTempLabel.text = "\(Int(currentWeather.main?.tempMin?.rounded() ?? 0))°/\(Int(currentWeather.main?.tempMax?.rounded() ?? 0))°"
//        sum2Label.text = "\(currentWeather.wind?.speed?.rounded() ?? 0) м/с"
//        sum3Label.text = "\(currentWeather.main?.humidity ?? 0)%"
//        sum2Label.text?.append("123")

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let sunriseText = formatter.string(from: Date(timeIntervalSince1970: (currentWeather.sys?.sunrise)! + currentWeather.timezone!))
        let sunsetText = formatter.string(from: Date(timeIntervalSince1970: (currentWeather.sys?.sunset)! + currentWeather.timezone!))
        sunriseLabel.text = sunriseText
        sunsetLabel.text = sunsetText

        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm, E d MMM"
        let currentDateText = formatter.string(from: Date(timeIntervalSince1970: currentWeather.dt! ))

        curentDateLabel.text = currentDateText
    }

}
