//
//  SettingView.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

protocol PopSettingsProtocol: AnyObject {
    func popToRoot()
}
protocol ReloadSettingsProtocol: AnyObject {
    func reloadWeatheData()
}

final class SettingsView: UIView {

    weak var popDelegate: PopSettingsProtocol?
    weak var reloadDelegate: ReloadSettingsProtocol?

    private var unsavedSettings: [UserSettings.SettingsKeys: Bool] = [
        .isFahrenheit: UserSettings.isFahrenheit,
        .isImperial: UserSettings.isImperial,
        .isTwelve: UserSettings.isTwelve,
        .isNotification: UserSettings.isNotification
    ]

    private let screenLabel: UILabel = {
        let label = UILabel()
        label.text = Titles.Settings.labelText
        label.font  = UIFont(name: Fonts.Rubik.medium.rawValue, size: 18)
        return label
    }()
    private let mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    private let temperatureStack = SettingsStack(title: Titles.Settings.temp, leftSegment: "C", rightSegment: "F",
                                                 selected: UserSettings.isFahrenheit ? 1 : 0)
    private let windStack = SettingsStack(title: Titles.Settings.wind, leftSegment: "mph", rightSegment: "м/с",
                                          selected: UserSettings.isImperial ? 0 : 1)
    private let timeStack = SettingsStack(title: Titles.Settings.time, leftSegment: "12", rightSegment: "24",
                                          selected: UserSettings.isTwelve ? 0 : 1)
    private let notificationStack = SettingsStack(title: Titles.Settings.not, leftSegment: "On", rightSegment: "Off",
                                                  selected: UserSettings.isNotification ? 0 : 1)
    private lazy var okButton = OrangeButton(title: Titles.Settings.buttonText,
                                             font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 16)!,
                                             action: okBtnDidTap)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9139999747, green: 0.9330000281, blue: 0.9800000191, alpha: 1)
        layer.cornerRadius = 10

        let elements = [screenLabel, mainVStack, temperatureStack, windStack, timeStack, notificationStack, okButton]
        addSubviews(to: self, elements: [screenLabel, mainVStack, okButton])
        mainVStack.addArrangedSubviews(to: mainVStack, elements: [temperatureStack, windStack, timeStack, notificationStack])
        enableConstraints(elements: elements)
        setupConstraints()

        temperatureStack.segmentDelegate = self
        windStack.segmentDelegate = self
        timeStack.segmentDelegate = self
        notificationStack.segmentDelegate = self

        notificationStack.isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            screenLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            screenLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26),

            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 60),

            okButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            okButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            okButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            okButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func okBtnDidTap() {
        UserSettings.isFahrenheit = unsavedSettings[.isFahrenheit]!
        UserSettings.isImperial = unsavedSettings[.isImperial]!
        UserSettings.isTwelve = unsavedSettings[.isTwelve]!
        UserSettings.isNotification = unsavedSettings[.isNotification]!
        reloadDelegate?.reloadWeatheData()
        popDelegate?.popToRoot()
    }

}

extension SettingsView: SettingsSegmentValueChange {
    func segmentValueChange(key: String) {
        switch key {
        case "F": unsavedSettings[.isFahrenheit] = true
        case "C": unsavedSettings[.isFahrenheit] = false
        case "mph": unsavedSettings[.isImperial] = true
        case "м/с": unsavedSettings[.isImperial] = false
        case "12": unsavedSettings[.isTwelve] = true
        case "24": unsavedSettings[.isTwelve] = false
        case "On": unsavedSettings[.isNotification] = true
        case "Off": unsavedSettings[.isNotification] = false
        default: return
        }
    }

    
}
