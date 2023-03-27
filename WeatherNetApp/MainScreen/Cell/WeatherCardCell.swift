//
//  WeatherCardCell.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

final class WeatherCardCell: UICollectionViewCell {

    static let id = "WeatherCard"

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        return stack
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:00"
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)
        return label
    }()

    private let weatherImageView = UIImageView(image: UIImage(named: "colorSun"))

    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "25°"
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.Rubik.regular.rawValue, size: 16)
        return label
    }()

    let icons = ["colorSun", "colorSunRain", "colorCloudy", "colorRain", "colorRaindrops", "colorStorm"]

    override init(frame: CGRect) {
        super.init(frame: .zero)
        weatherImageView.image = UIImage(named: icons.randomElement()!)
        weatherImageView.contentMode = .scaleAspectFit

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let elements = [stackView, timeLabel, weatherImageView, tempLabel]
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(to: stackView, elements: [timeLabel, weatherImageView, tempLabel])
        enableConstraints(elements: elements)
//        backgroundColor = .systemBlue
        layer.borderWidth = 0.5
        layer.cornerRadius = 21
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

        ])
    }

    func fillCell(index: Int) {
        tempLabel.text = " \(Int.random(in: -30...40))°"
        timeLabel.text = "\(index + 8):00"
    }

}
