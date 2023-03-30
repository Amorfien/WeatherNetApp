//
//  SettingsViewController.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

final class SettingsViewController: UIViewController {

    private let grayView = SettingsView()

    private let cloudOne = UIImageView(image: UIImage(named: "cloud0"))
    private let cloudTwo = UIImageView(image: UIImage(named: "cloud1"))
    private let cloudThree = UIImageView(image: UIImage(named: "cloud2"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.125, green: 0.3059999943, blue: 0.7799999714, alpha: 1)

        let elements = [grayView, cloudOne, cloudTwo, cloudThree]
        addSubviews(to: view, elements: elements)
        enableConstraints(elements: elements)
        navigationController?.navigationBar.tintColor = .white
        setupConstraints()
        animation()
        grayView.popDelegate = self
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            grayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            grayView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            grayView.widthAnchor.constraint(equalToConstant: 320),
            grayView.heightAnchor.constraint(equalToConstant: 330),

            cloudOne.topAnchor.constraint(equalTo: view.topAnchor, constant: 37),
            cloudOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),

            cloudTwo.topAnchor.constraint(equalTo: view.topAnchor, constant: 121),
            cloudTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            cloudThree.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cloudThree.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -140)
        ])
    }

    private func animation() {
        UIView.animate(withDuration: 25) {
            self.cloudOne.frame.origin.x -= 330
            self.cloudTwo.frame.origin.x += 200
            self.cloudThree.frame.origin.y -= 80
        }
    }

}

extension SettingsViewController: PopSettingsProtocol {
    func popToRoot() {
        navigationController?.popViewController(animated: true)
    }
}
