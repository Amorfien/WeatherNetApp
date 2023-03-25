//
//  DailyCollectionViewCell.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 25.03.2023.
//

import UIKit

final class DailyCollectionViewCell: UICollectionViewCell {

    static let id = "DailyCard"

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
    }

    private func setupConstraints() {
        
    }



}
