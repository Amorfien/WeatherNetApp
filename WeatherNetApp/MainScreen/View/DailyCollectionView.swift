//
//  DailyCollectionView.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 25.03.2023.
//

import UIKit

protocol SummaryDelegate: AnyObject {
    func tapToSummary()
}

final class DailyCollectionView: UICollectionView {

    weak var summaryDelegate: SummaryDelegate?

    let cellHeight: CGFloat = 56
    let inset: CGFloat = 10
    var numberOfCells: CGFloat = 7//

    private var forecast: ForecastWeatherModel? {
        didSet {
            self.reloadData()
        }
    }

    private let dailyLayout = UICollectionViewFlowLayout()

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

    func fillDailyCollection(forecast: ForecastWeatherModel?) {
        self.forecast = forecast
        newDaysArray() // temp
    }

    // заполнение даты в нужном формате начиная с завтра и т.д.
    private func futureDates(indx: Int, timezone: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        dateFormatter.timeZone = .gmt
        let today = Calendar.current.date(byAdding: .second, value: timezone, to: .now)
        let nextDate = Calendar.current.date(byAdding: .day, value: indx + 1, to: today!)
        return dateFormatter.string(from: nextDate!)
    }

    private func newDaysArray() -> [List] {
        guard let forecastList = (forecast?.list) else {return []}
        let timezone = forecast?.city?.timezone

        // поиск начала нового дня
        for (index, day) in forecastList.enumerated() {
            if (day.dt! + timezone!) % (24 * 60 * 60) == 0 {
                let slicedArray = [List](forecastList[index..<forecastList.count])
                print("🤥", index)
                print("😶‍🌫️", slicedArray.count)
                return slicedArray
            }
        }
        return []
    }

    private func forecastTemp(day: Int) -> String {
        guard newDaysArray().count > ((day + 1) * 8) else {
            return "??°-??°"
        }
        let needDay = newDaysArray()[(8 * day) ..< (8 * (day + 1))]
        var tempDayArray: [Double] = []
        for hour in needDay {
            tempDayArray.append(hour.main?.temp ?? 0)
        }

        let minCelsium = Int(tempDayArray.min()?.rounded() ?? 0)
        let minFahrenheit = minCelsium * 9 / 5 + 32
        let maxCelsium = Int(tempDayArray.max()?.rounded() ?? 0)
        let maxFahrenheit = maxCelsium * 9 / 5 + 32

        return UserSettings.isFahrenheit ? "\(minFahrenheit)°-\(maxFahrenheit)°" : "\(minCelsium)°-\(maxCelsium)°"
    }

}
//for newday in slicedArray {
//
//}
//let tempRange = "\(tempArray.min() ?? 0)°-\(tempArray.max() ?? 0)°"



extension DailyCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Int(numberOfCells)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.id, for: indexPath) as? DailyCollectionViewCell {
            let futureDate = futureDates(indx: indexPath.item, timezone: forecast?.city?.timezone ?? 0)
            let tempRange = forecastTemp(day: indexPath.item)
            cell.fillDailyCell(date: futureDate, title: "1", ico: "colorRain", value: "2", range: tempRange)
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
        print(indexPath)
        summaryDelegate?.tapToSummary()
    }
}
