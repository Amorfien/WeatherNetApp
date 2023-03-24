//
//  ViewController.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 22.03.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {

    private let logoImageView = UIImageView(image: UIImage(named: "onboardGirl"))

    private let firstLabel: UILabel = {
        let label = UILabel()
        label.text = Titles.Onboarding.text1
        label.textColor = #colorLiteral(red: 0.9725490196, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "Rubik-SemiBold", size: 16)
        label.numberOfLines = 0
        return label
    }()

    private let secondLabel: UILabel = {
        let label = UILabel()
        label.text = Titles.Onboarding.text2
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "RubikRoman-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()

    private let thirdLabel: UILabel = {
        let label = UILabel()
        label.text = Titles.Onboarding.text3
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "RubikRoman-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()

    private lazy var locationButton: LocationButton = {
        let button = LocationButton()
        button.setTitle(Titles.Onboarding.okText, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "RubikRoman-Medium", size: 12)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.431372549, blue: 0.06666666667, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(locationTap), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(Titles.Onboarding.cancelText, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont(name: "RubikRoman-Regular", size: 16)
        button.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.125, green: 0.3059999943, blue: 0.7799999714, alpha: 1)
        let elements = [logoImageView, firstLabel, secondLabel, thirdLabel, locationButton, cancelButton]
        addSubviews(view: view, elements: elements)
        enableConstraints(elements: elements)
        setupConstraints()
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width * 0.04),
            logoImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            logoImageView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.48),

            firstLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -4),
            firstLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),

            secondLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 60),

            thirdLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thirdLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            thirdLabel.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 14),

            locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            locationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -123),
            locationButton.heightAnchor.constraint(equalToConstant: 40),

            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -77),
            cancelButton.trailingAnchor.constraint(equalTo: locationButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    @objc private func cancelTap() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    @objc private func locationTap() {
    }

}

