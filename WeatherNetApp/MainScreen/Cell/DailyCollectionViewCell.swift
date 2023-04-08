//
//  DailyCollectionViewCell.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 25.03.2023.
//

import UIKit

final class DailyCollectionViewCell: UICollectionViewCell {

    static let id = "DailyCard"

    private let textArray = ["Местами дождь", "Преимущественно облачно даже очень", "Облачно", "Небольшой ливневый дождь", "Ливни", "Солнечно"]

    private let dateLabel = UILabel(text: "17/04", textColor: #colorLiteral(red: 0.6039215686, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
    private let icoButton = UIButton(title: "57%", font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 12)!, leftImage: UIImage(named: "colorRain")!)
    private let textLabel = UILabel(text: "Местами дождь")
    private let tempRangeLabel = UILabel(text: "4°-11°", font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 18)!, alignment: .right)
    private lazy var detailButton = SimpleButton(image: UIImage(systemName: "chevron.right")!, action: detailButtonDidTap)

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.9139999747, green: 0.9330000281, blue: 0.9800000191, alpha: 1)
        layer.cornerRadius = 5
        detailButton.tintColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1)
        icoButton.setTitleColor(#colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1), for: .normal)
        let elements = [dateLabel, icoButton, textLabel, tempRangeLabel, detailButton]
        addSubviews(to: self, elements: elements)

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            icoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            icoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 66),
//            textLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -60),
            textLabel.widthAnchor.constraint(equalToConstant: 200),

            detailButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            tempRangeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            tempRangeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
//            tempRangeLabel.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -80)

        ])
    }

    func fillDailyCell(text: String, indx: Int) {
//        textLabel.text = text
        textLabel.text = textArray.randomElement()
        inputFormatDate(indx: indx)
    }

    private func inputFormatDate(indx: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: indx + 1, to: today)
        dateLabel.text = dateFormatter.string(from: nextDate!)
    }

    private func detailButtonDidTap() {
    }


}
