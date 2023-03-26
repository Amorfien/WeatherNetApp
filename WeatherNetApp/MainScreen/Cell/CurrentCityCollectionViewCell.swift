//
//  CurrentCityCollectionViewCell.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 26.03.2023.
//

import UIKit

final class CurrentCityCollectionViewCell: UICollectionViewCell {

    static let id = "CityScreen"

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .brown
        return scrollView
    }()


    private let dailyView = DailyView()
    private let detailButton = UIButton(underlined: "Подробнее на 24 часа")

    private let weatherCardsCollectionView = WeatherCardsCollectionView()

    private let stackView = UIStackView()
    private let dailyLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Rubik.medium.rawValue, size: 18)
        label.text = "Ежедневный прогноз"
        return label
    }()
    private let moreDaysButton = UIButton(underlined: "25 дней")

    private let dailyCollectionView = DailyCollectionView()


    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .green
        let elements = [scrollView, dailyView, detailButton, weatherCardsCollectionView, stackView, dailyLable, moreDaysButton, dailyCollectionView]
        addSubview(scrollView)
        scrollView.addSubviews(view: scrollView, elements: [dailyView, detailButton, weatherCardsCollectionView, stackView, dailyCollectionView])
        stackView.addArrangedSubviews(stack: stackView, elements: [dailyLable, moreDaysButton])
        enableConstraints(elements: elements)
        setupConstraints()
        DispatchQueue.main.async {
            self.setContentSize()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setContentSize() {
        var contentRect = CGRect.zero
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        scrollView.contentSize.height = contentRect.maxY + 70
        print("---", contentRect.maxY)
    }


    private func setupConstraints() {
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            scrollView.heightAnchor.constraint(equalToConstant: 2000),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            dailyView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            dailyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dailyView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dailyView.heightAnchor.constraint(equalToConstant: 212),

            detailButton.topAnchor.constraint(equalTo: dailyView.bottomAnchor, constant: 28),
            detailButton.trailingAnchor.constraint(equalTo: dailyView.trailingAnchor),

            weatherCardsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherCardsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherCardsCollectionView.topAnchor.constraint(equalTo: detailButton.bottomAnchor, constant: 24),
            weatherCardsCollectionView.heightAnchor.constraint(equalToConstant: 85),

            stackView.topAnchor.constraint(equalTo: weatherCardsCollectionView.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: dailyView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: dailyView.trailingAnchor),

            dailyCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            dailyCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            dailyCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dailyCollectionView.heightAnchor.constraint(equalToConstant: dailyCollectionView.numberOfCells * (dailyCollectionView.cellHeight + dailyCollectionView.inset) + dailyCollectionView.inset)
//            dailyCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)

        ])
    }


}
