//
//  TodayDetailsCollectionViewCell.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 27.03.2023.
//

import UIKit

final class TodayDetailsCollectionViewCell: UICollectionViewCell {

    static let id = "TodayDetailsCell"

    private let blueLine = UIView()
    private let dateLabel = UILabel(text: "пт 16/04", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 18)!)
    private let timeLabel = UILabel(text: "12:00", font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)!, textColor: #colorLiteral(red: 0.6039215686, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
    private let tempLabel = UILabel(text: "12°", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 18)!)
    private var verticalStackView = UIStackView()


    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(dateLabel)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.9139999747, green: 0.9330000281, blue: 0.9800000191, alpha: 1)
        blueLine.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        timeLabel.textAlignment = .center
        let elements = [dateLabel, timeLabel, tempLabel, verticalStackView, blueLine]
        enableConstraints(elements: elements)
//        fillVerticalStack(values: ["10°", "2 м/с ССЗ", "0%", "29%"])//
        addSubviews(to: self, elements: elements)

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 22),

            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 73),

            tempLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),

            blueLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            blueLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            blueLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            blueLine.heightAnchor.constraint(equalToConstant: 1),

            verticalStackView.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)

        ])
    }

//    private enum WeatherStack: String {
//        case temp = "Ощущается как"
//        case wind = "Ветер"
//        case rainfall = "Влажность"
//        case cloud = "Облачность"
//    }

    private func makeHStackView(value: String, type: WeatherStackType) -> UIStackView {
        let stackView = UIStackView()
        var imageName = ""
        switch type {
        case .temp: imageName = "colorMoon"
        case .wind: imageName = "colorWind"
        case .ultraviolet: imageName = "colorSun"
        case .rainfall: imageName = "colorRaindrops"
        case .cloud: imageName = "colorCloudy"
        }
        let firstLabel = UILabel(ico: UIImage(named: imageName)!, value: type.rawValue, font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)!, textColor: #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1))
        let secondLabel = UILabel(text: value, font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)!, textColor: #colorLiteral(red: 0.6039215686, green: 0.5882352941, blue: 0.5882352941, alpha: 1), alignment: .right)
        stackView.addArrangedSubview(firstLabel)
        stackView.addArrangedSubview(secondLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func fillVerticalStack(values: [String]) {
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        guard values.count == 4 else { return }
        verticalStackView.addArrangedSubview(makeHStackView(value: values[0], type: .temp))
        verticalStackView.addArrangedSubview(makeHStackView(value: values[1], type: .wind))
        verticalStackView.addArrangedSubview(makeHStackView(value: values[2], type: .rainfall))
        verticalStackView.addArrangedSubview(makeHStackView(value: values[3], type: .cloud))
    }

    func fillTodayCell(date: String, time: String, temp: String, values: [String]) {
        dateLabel.text = date
        timeLabel.text = time
        tempLabel.text = temp
        fillVerticalStack(values: values)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        fillVerticalStack(values: [""])
        verticalStackView = UIStackView()
    }


}
