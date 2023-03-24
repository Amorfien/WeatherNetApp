//
//  SettingView.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

final class SettingsView: UIView {

    private let screenLabel: UILabel = {
        let label = UILabel()
        label.text = Resources.Settings.labelText
        label.font  = UIFont(name: "RubikRoman-Medium", size: 18)
        return label
    }()
    private let mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    private let temperatureStack = SettingsStack(title: Resources.Settings.temp, leftSegment: "C", rightSegment: "F", selected: 0)
    private let windStack = SettingsStack(title: Resources.Settings.wind, leftSegment: "Mi", rightSegment: "Km", selected: 1)
    private let timeStack = SettingsStack(title: Resources.Settings.time, leftSegment: "12", rightSegment: "24", selected: 1)
    private let notificationStack = SettingsStack(title: Resources.Settings.not, leftSegment: "On", rightSegment: "Off", selected: 0)
    private lazy var okButton: LocationButton = {
        let button = LocationButton()
        button.setTitle(Resources.Settings.buttonText, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "RubikRoman-Regular", size: 16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.431372549, blue: 0.06666666667, alpha: 1)
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(locationTap), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9139999747, green: 0.9330000281, blue: 0.9800000191, alpha: 1)
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false

        let elements = [screenLabel, mainVStack, temperatureStack, windStack, timeStack, notificationStack, okButton]
//        addSubviews(view: self, elements: [temperatureStack])
        addSubviews(view: self, elements: [screenLabel, mainVStack, okButton])
        mainVStack.addArrangedSubviews(stack: mainVStack, elements: [temperatureStack, windStack, timeStack, notificationStack])
        enableConstraints(elements: elements)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            screenLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            screenLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),

            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 57),
//            mainVStack.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -37),

            okButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            okButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            okButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            okButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}
