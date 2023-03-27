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
    private let textLabel = UILabel(text: "Местами дождь ")

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(textLabel)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.9139999747, green: 0.9330000281, blue: 0.9800000191, alpha: 1)
        blueLine.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        let elements = [textLabel, blueLine]
        enableConstraints(elements: elements)
        addSubviews(to: self, elements: elements)
//        layer.cornerRadius = 5
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 19),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 66),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -72),

            blueLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            blueLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            blueLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            blueLine.heightAnchor.constraint(equalToConstant: 1)



        ])
    }

    func fillCell(text: String) {
        textLabel.text = text
    }



}
