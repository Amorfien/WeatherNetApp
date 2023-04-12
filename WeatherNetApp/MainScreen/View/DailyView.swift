//
//  DailyView.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

final class DailyView: UIView {

    private let sunLayer: CAShapeLayer = {
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
        // сплющиваю слой, т.к. неправильно отрисовал путь (полукруг вместо элипса)
        // в таком варианте не получится пустить солнышко по траектории если понадобится ((
        layer.transform = CATransform3DMakeScale(1, 0.8, 1)
        return layer
    }()

    private let sum1Button = UIButton(title: "--%", leftImage: UIImage(named: "colorSunCloud")!)
    private let sum2Button = UIButton(title: "- м/с", leftImage: UIImage(named: "colorWind")!)
    private let sum3Button = UIButton(title: "--%", leftImage: UIImage(named: "colorRaindrops")!)

    private lazy var summaryStack = UIStackView(arrangedSubviews: [sum1Button, sum2Button, sum3Button])

    private let curentDateLabel = UILabel(text: "00:00, -- 00 ----", textColor: #colorLiteral(red: 0.9647058824, green: 0.8666666667, blue: 0.003921568627, alpha: 1), alignment: .center)
    private let weatherLabel = UILabel(text: "Возможен небольшой дождь", textColor: .white, alignment: .center)
    private let tempLabel = UILabel(text: " --°", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 36)!, textColor: .white, alignment: .center)
    private let rangeTempLabel = UILabel(text: "--°/--°", textColor: .white, alignment: .center)
    private let sunriseIco = UIImageView(image: UIImage(named: "sunrise_yellow"))
    private let sunsetIco = UIImageView(image: UIImage(named: "sunset_yellow"))
    private let sunriseLabel = UILabel(text: "00:00", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 14)!, textColor: .white)
    private let sunsetLabel = UILabel(text: "00:00", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 14)!, textColor: .white)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        layer.cornerRadius = 5

        summaryStack.distribution = .equalCentering
//        summaryStack.spacing = 10


        layer.addSublayer(sunLayer)
        addSubviews(to: self, elements: [curentDateLabel, summaryStack, weatherLabel, tempLabel, rangeTempLabel,
                                         sunriseIco, sunsetIco, sunriseLabel, sunsetLabel])
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            curentDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            curentDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            curentDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            summaryStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            summaryStack.bottomAnchor.constraint(equalTo: curentDateLabel.topAnchor, constant: -16),
            summaryStack.heightAnchor.constraint(equalToConstant: 18),
            summaryStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65),

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
    // MARK: - private method
    private func dateFormat(currentDate: Bool, amStyle: Bool = false) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        if amStyle {
            formatter.dateFormat = currentDate ? "hh:mm a, E d MMMM" : "hh:mm a"
        } else {
            formatter.dateFormat = currentDate ? "HH:mm, E d MMMM" : "HH:mm"
        }
        formatter.timeZone = .gmt
        return formatter
    }

    // MARK: - public method
    func fillView(currentWeather: CurrentWeatherModel?) {
        guard let currentWeather else { return }
        sum1Button.setImage(UIImage(named: ImageDictionary.dictionary[currentWeather.weather?.first?.icon ?? "noIco"] ?? "colorSunCloud"), for: .normal)
        let tempCelsium = Int(currentWeather.main?.temp?.rounded() ?? 0)
        let tempFahrenheit = tempCelsium * 9 / 5 + 32
        tempLabel.text = UserSettings.isFahrenheit ? "\(tempFahrenheit)°F" : "\(tempCelsium)°C"
        weatherLabel.text = currentWeather.weather?[0].description?.capitalizingFirstLetter()
        let minCelsium = Int(currentWeather.main?.tempMin?.rounded() ?? 0)
        let minFahrenheit = minCelsium * 9 / 5 + 32
        let maxCelsium = Int(currentWeather.main?.tempMax?.rounded() ?? 0)
        let maxFahrenheit = maxCelsium * 9 / 5 + 32
        rangeTempLabel.text = UserSettings.isFahrenheit ?
                            "\(minFahrenheit)°/\(maxFahrenheit)°" :
                            "\(minCelsium)°/\(maxCelsium)°"
        sum1Button.setTitle("\(currentWeather.clouds?.all ?? 0)%", for: .normal)
        let windRatio = UserSettings.isImperial ? 2.237 : 1
        let ending = UserSettings.isImperial ? " mph" : " м/с"
        let windSpeed = (currentWeather.wind?.speed?.rounded() ?? 0) * windRatio
        sum2Button.setTitle(String(Int(windSpeed)) + ending, for: .normal)
        sum3Button.setTitle("\(currentWeather.main?.humidity ?? 0)%", for: .normal)

        let timeZone = Double(currentWeather.timezone ?? 0)
        let sunriseText = dateFormat(currentDate: false, amStyle: UserSettings.isTwelve).string(from: Date(timeIntervalSince1970: (currentWeather.sys?.sunrise)! + timeZone))
        let sunsetText = dateFormat(currentDate: false, amStyle: UserSettings.isTwelve).string(from: Date(timeIntervalSince1970: (currentWeather.sys?.sunset)! + timeZone))
        sunriseLabel.text = sunriseText
        sunsetLabel.text = sunsetText

        let localTime = Date() + timeZone
        let currentDateText = dateFormat(currentDate: true, amStyle: UserSettings.isTwelve).string(from: localTime)

        curentDateLabel.text = currentDateText
    }

}
