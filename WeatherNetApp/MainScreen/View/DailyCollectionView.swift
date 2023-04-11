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

    private var forecast: ForecastWeatherModel? {
        didSet {
            newDaysArray()
        }
    }
    private var futureDays: [List] = [] {
        didSet {
            self.reloadData()
        }
    }

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

    // MARK: - private methods
    /// заполнение даты в нужном формате начиная с завтра и т.д.
    private func futureDates(indx: Int, timezone: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        dateFormatter.timeZone = .gmt
        let today = Calendar.current.date(byAdding: .second, value: timezone, to: .now)
        let nextDate = Calendar.current.date(byAdding: .day, value: indx + 1, to: today!)
        return dateFormatter.string(from: nextDate!)
    }

    /// создание нового массива путём отсечения сеодняшнего дня
    private func newDaysArray() {
        guard let forecastList = (forecast?.list) else {
            print("NO LIST")
            return
        }
        let timezone = forecast?.city?.timezone

        // поиск начала нового дня
        // из-за разного смещения часов в каждом городе не везде есть прогноз на 00:00
        // поэтому ищу остаток от деления меньше чем три часа
        for (index, day) in forecastList.enumerated() {
            if (day.dt! + timezone!) % (24 * 60 * 60) < (3 * 60 * 60) {
                let slicedArray = [List](forecastList[index..<forecastList.count])
                futureDays = slicedArray
                return
            }
        }
    }

    /// получение диаапазона температур на заданный день
    private func forecastTemp(day: Int) -> String {
        guard futureDays.count > ((day + 1) * 8) else {
            return "??°-??°"
        }
        let needDay = futureDays[(8 * day) ..< (8 * (day + 1))]
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

    /// получение средней влажности на заданный день
    private func averageHumidity(day: Int) -> String {
        guard futureDays.count > ((day + 1) * 8) else {
            return "?%"
        }
        let needDay = futureDays[(8 * day) ..< (8 * (day + 1))]
        var humidity: Int = 0
        for hour in needDay {
            humidity += hour.main?.humidity ?? 0
        }

        return "\(humidity / 8)%"
    }

    /// метод поиска самых повторяющиххся значений в массиве строк
    private func commonElementsInArray(stringArray: [String]) -> String {
        let dict = Dictionary(grouping: stringArray, by: {$0})
        let newDict = dict.mapValues({$0.count})
        return newDict.sorted(by: {$0.value > $1.value}).first?.key ?? ""
    }

    /// преобладающее текстовое описание погоды на заданный день
    private func primaryDescription(day: Int) -> String {
        guard futureDays.count > ((day + 1) * 8) else {
            return "--no data available--"
        }
        let needDay = [List](futureDays[(8 * day) ..< (8 * (day + 1))])
        var weatherDescription: [String] = []
        for hour in needDay {
            weatherDescription.append(hour.weather?.first?.description ?? "")
        }
        let result = commonElementsInArray(stringArray: weatherDescription)

        return result
    }

    /// преобладающая иконка погоды на заданный день
    private func primaryIco(day: Int) -> String {
        guard futureDays.count > ((day + 1) * 8) else {
            return "fog"
        }
        let needDay = [List](futureDays[(8 * day) ..< (8 * (day + 1))])
        var weatherIco: [String] = []
        for hour in needDay {
            weatherIco.append(hour.weather?.first?.icon ?? "fog")
        }
        let result = commonElementsInArray(stringArray: weatherIco)

        return result
    }

}

// MARK: - setup collectionview
extension DailyCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Int(numberOfCells)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.id, for: indexPath) as? DailyCollectionViewCell {
            let futureDate = futureDates(indx: indexPath.item, timezone: forecast?.city?.timezone ?? 0)
            let title = primaryDescription(day: indexPath.item)
            let ico = ImageDictionary.noNight[primaryIco(day: indexPath.item)] ?? "fog"
            let tempRange = forecastTemp(day: indexPath.item)
            let humidity = averageHumidity(day: indexPath.item)
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
