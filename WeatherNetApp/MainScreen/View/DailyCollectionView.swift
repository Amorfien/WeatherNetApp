//
//  DailyCollectionView.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 25.03.2023.
//

import UIKit

protocol SummaryDelegate: AnyObject {
    func tapToSummary(indx: Int)
}

final class DailyCollectionView: UICollectionView {

    weak var summaryDelegate: SummaryDelegate?

    let cellHeight: CGFloat = 56
    let inset: CGFloat = 10
    var numberOfCells: CGFloat = 7

    private var forecast: ForecastWeatherModel? //{
//        didSet {
//            newDaysArray()
//        }
//    }
//    private var futureDays: [List] = [] {
//        didSet {
//            self.reloadData()
//        }
//    }

    private let dailyLayout = UICollectionViewFlowLayout()

    // MARK: - init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: dailyLayout)
        dailyLayout.sectionInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        register(DailyCollectionViewCell.self, forCellWithReuseIdentifier: DailyCollectionViewCell.id)
        showsVerticalScrollIndicator = false
        isScrollEnabled = false
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - public method
    func fillDailyCollection(forecast: ForecastWeatherModel?) {
        self.forecast = forecast
//        newDaysArray() // temp
    }

}

// MARK: - setup collectionview
extension DailyCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Int(numberOfCells)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.id, for: indexPath) as? DailyCollectionViewCell {

            let weatherService = WeatherService(forecast: forecast)

            let futureDate = weatherService.futureDates(indx: indexPath.item, timezone: forecast?.city?.timezone ?? 0, weekDay: false)
            let title = weatherService.primaryDescription(day: indexPath.item)
            let ico = ImageDictionary.noNight[weatherService.primaryIco(day: indexPath.item)] ?? "fog"
            let tempRange = weatherService.forecastTemp(day: indexPath.item)
            let humidity = weatherService.averageHumidity(day: indexPath.item)
            cell.fillDailyCell(date: futureDate, title: title, ico: ico, value: humidity, range: tempRange)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
extension DailyCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 32, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        summaryDelegate?.tapToSummary(indx: indexPath.item)
    }
}
