//
//  CalendarCollectionViewCell.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 28.03.2023.
//

import UIKit

final class CalendarCollectionViewCell: UICollectionViewCell {

    static let id = "CalendarViewCell"

    let dateLabel = UILabel(text: "16/04 ПТ", font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 18)!)

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1) : .white
            dateLabel.textColor = isSelected ? .white : #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1)
        }
    }

    private let whiteView = UIView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupView() {
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        addSubviews(to: self, elements: [dateLabel])
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public method
    func fillCalendarCell(date: String) {
        dateLabel.text = date
    }



}
