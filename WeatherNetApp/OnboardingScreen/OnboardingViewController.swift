//
//  ViewController.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 22.03.2023.
//

import UIKit
import CoreLocation

final class OnboardingViewController: UIViewController {

    let locationManager = CLLocationManager()

    private let logoImageView = UIImageView(image: UIImage(named: "onboardGirl"))

    private let firstLabel: UILabel = {
        let label = UILabel()
        label.text = Titles.Onboarding.text1
        label.textColor = #colorLiteral(red: 0.9725490196, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.Rubik.semiBold.rawValue, size: 16)
        label.numberOfLines = 0
        return label
    }()

    private let secondLabel: UILabel = {
        let label = UILabel()
        label.text = Titles.Onboarding.text2
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)
        label.numberOfLines = 0
        return label
    }()

    private let thirdLabel: UILabel = {
        let label = UILabel()
        label.text = Titles.Onboarding.text3
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)
        label.numberOfLines = 0
        return label
    }()

    private lazy var locationButton = OrangeButton(title: Titles.Onboarding.okText,
                                                   font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 12)!,
                                                   action: locationTap)

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(Titles.Onboarding.cancelText, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont(name: Fonts.Rubik.regular.rawValue, size: 16)
        button.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.125, green: 0.3059999943, blue: 0.7799999714, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        let elements = [logoImageView, firstLabel, secondLabel, thirdLabel, locationButton, cancelButton]
        addSubviews(to: view, elements: elements)
        enableConstraints(elements: elements)
        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .darkText
    }

    // MARK: - UI
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

    // MARK: - Buttons action
    private func locationTap() {

        locationManager.delegate = self
        if locationManager.authorizationStatus != .authorizedAlways || locationManager.authorizationStatus != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            let mainVC = MainScreenWithCollectionView(isGeoTracking: true)
            navigationController?.pushViewController(mainVC, animated: true)
        }

    }

    @objc private func cancelTap() {
//        UserSettings.isOnboarding = true
        let mainVC = MainScreenWithCollectionView(isGeoTracking: false)
        navigationController?.pushViewController(mainVC, animated: true)
    }

}

// MARK: - Location Manager Delegate
extension OnboardingViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
//            UserSettings.isOnboarding = true
            let mainVC = MainScreenWithCollectionView(isGeoTracking: true)
            navigationController?.pushViewController(mainVC, animated: true)
        }

    }
}
