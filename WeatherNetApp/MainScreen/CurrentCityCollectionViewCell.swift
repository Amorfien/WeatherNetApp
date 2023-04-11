//
//  CurrentCityCollectionViewCell.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 26.03.2023.
//

import UIKit

protocol DetailDelegate: AnyObject {
    func showDetail(forecast: ForecastWeatherModel?)
    func showSummary(forecast: ForecastWeatherModel?, indx: Int)
}

final class CurrentCityCollectionViewCell: UICollectionViewCell {

    static let id = "CityScreen"

//    private var currentWeather: CurrentWeatherModel? //{
//        didSet {
//            self.weatherCardsCollectionView.coordinates = (self.currentWeather?.coord?.lon ?? 0, self.currentWeather?.coord?.lat ?? 0, self.currentWeather?.timezone ?? 0)
//        }
//    }
//    private var forecast: ForecastWeatherModel?


    weak var detailDelegate: DetailDelegate?

    private let scrollView = UIScrollView()

    private let dailyView = DailyView()

    private lazy var detailButton = UnderlinedButton(underlined: "Подробнее на 24 часа", action: detailDidTap)

    private let weatherCardsCollectionView = WeatherCardsCollectionView()

    private let dailyLable = UILabel(text: "Ежедневный прогноз", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 18)!)

    private lazy var moreDaysButton = UnderlinedButton(underlined: "25 дней", action: moreDaysDidTap)

    private var dailyCollectionView = DailyCollectionView()

    private var forecast: ForecastWeatherModel?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let elements = [scrollView, dailyView, detailButton, weatherCardsCollectionView, dailyLable, moreDaysButton, dailyCollectionView]
        addSubview(scrollView)
        scrollView.addSubviews(to: scrollView, elements: [dailyView, detailButton, weatherCardsCollectionView, dailyLable, moreDaysButton, dailyCollectionView])
        enableConstraints(elements: elements)
        setupConstraints()
        scrollView.showsVerticalScrollIndicator = false
//        scrollView.bounces = false
        DispatchQueue.main.async {
            self.setContentSize()
        }
        moreDaysButton.titleLabel?.textAlignment = .right
        dailyCollectionView.summaryDelegate = self

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setContentSize() {
        var contentRect = CGRect.zero
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        scrollView.contentSize.height = contentRect.maxY
    }


    private func setupConstraints() {
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
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

//            stackView.topAnchor.constraint(equalTo: weatherCardsCollectionView.bottomAnchor, constant: 24),
//            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dailyLable.topAnchor.constraint(equalTo: weatherCardsCollectionView.bottomAnchor, constant: 24),
            dailyLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            moreDaysButton.centerYAnchor.constraint(equalTo: dailyLable.centerYAnchor),
            moreDaysButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            dailyCollectionView.topAnchor.constraint(equalTo: dailyLable.bottomAnchor),
            dailyCollectionView.widthAnchor.constraint(equalTo: widthAnchor),
            dailyCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dailyCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: dailyCollectionView.numberOfCells * (dailyCollectionView.cellHeight + dailyCollectionView.inset) + dailyCollectionView.inset + 80),
            dailyCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)

        ])
    }

    // MARK: - public method
    func fillCityCell(currentWeather: CurrentWeatherModel?, forecast: ForecastWeatherModel?) {
        dailyView.fillView(currentWeather: currentWeather)
        weatherCardsCollectionView.fillCardsCollection(forecast: forecast)
        dailyCollectionView.fillDailyCollection(forecast: forecast)
        self.forecast = forecast
    }

    // MARK: - private methods
    private func detailDidTap() {
        detailDelegate?.showDetail(forecast: forecast)
    }

    private func moreDaysDidTap() {
        if moreDaysButton.titleLabel?.text == "25 дней" {
            dailyCollectionView.numberOfCells = 25
            moreDaysButton.setTitle("7 дней", for: .normal)
            scrollView.contentSize.height += 18 * (dailyCollectionView.cellHeight + dailyCollectionView.inset) + dailyCollectionView.inset
        } else if moreDaysButton.titleLabel?.text == "7 дней" {
            dailyCollectionView.numberOfCells = 7
            moreDaysButton.setTitle("25 дней", for: .normal)
            scrollView.contentSize.height -= 18 * (dailyCollectionView.cellHeight + dailyCollectionView.inset) + dailyCollectionView.inset
        }
        dailyCollectionView.reloadData()
        setupConstraints()
    }

}

// MARK: - delegates
extension CurrentCityCollectionViewCell: SummaryDelegate {
    func tapToSummary(indx: Int) {
        print("peredacha #1")
        detailDelegate?.showSummary(forecast: forecast, indx: indx)
    }
}
