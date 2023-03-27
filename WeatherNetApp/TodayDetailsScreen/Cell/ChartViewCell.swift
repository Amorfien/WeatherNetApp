//
//  ChartViewCell.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 27.03.2023.
//

import UIKit

final class ChartViewCell: UICollectionViewCell {

    static let id = "ChartViewCell"

    private let whiteView = UIView()

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
        whiteView.backgroundColor = .white

        let elements = [whiteView]
        enableConstraints(elements: elements)
        addSubviews(to: self, elements: elements)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            whiteView.leadingAnchor.constraint(equalTo: leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: trailingAnchor),
            whiteView.topAnchor.constraint(equalTo: topAnchor, constant: 152),
            whiteView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
    }

    func fillCell(text: String) {

    }



}
