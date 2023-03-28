//
//  SummaryView.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 28.03.2023.
//

import UIKit

final class SummaryView: UIView {

    private var isDay: Bool

    private var dayLabel = UILabel(text: "", font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 18)!)
    private var tempLabel = UILabel(ico: UIImage(named: "colorSun")!, value: "13°", font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 30)!, textColor: #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1))
    private var specLabel = UILabel(text: "Ливни", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 18)!, textColor: #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1), alignment: .center)

    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    private var stack1, stack2, stack3, stack4, stack5: WeatherStack

    init(isDay: Bool, _ tempValue: String, _ windValue: String, _ uvValue: String, _ rainValue: String, _ clouddValue: String) {
        self.isDay = isDay
        dayLabel.text = isDay ? "День" : "Ночь"
        stack1 = WeatherStack(title: .temp, value: tempValue, separator: true)
        stack2 = WeatherStack(title: .wind, value: windValue, separator: true)
        stack3 = WeatherStack(title: .ultraviolet, value: uvValue, separator: true)
        stack4 = WeatherStack(title: .rainfall, value: rainValue, separator: true)
        stack5 = WeatherStack(title: .cloud, value: clouddValue, separator: true)


        


        vStack.addArrangedSubviews(to: vStack, elements: [stack1, stack2, stack3, stack4, stack5])
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.9294117647, blue: 0.9764705882, alpha: 1)
        layer.cornerRadius = 5
        addSubviews(to: self, elements: [dayLabel, tempLabel, specLabel, vStack])
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 21),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            dayLabel.heightAnchor.constraint(equalToConstant: 20),

            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            tempLabel.heightAnchor.constraint(equalToConstant: 32),

            specLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            specLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 10),
            specLabel.heightAnchor.constraint(equalToConstant: 20),

            vStack.topAnchor.constraint(equalTo: specLabel.bottomAnchor, constant: 24),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),

            
        ])
    }
//    func fillView(isDay: Bool) {
//        self.isDay = isDay
//        dayLabel.text = isDay ? "День" : "Ночь"
//    }
}
