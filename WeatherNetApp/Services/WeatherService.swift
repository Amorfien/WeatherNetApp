//
//  WeatherService.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 11.04.2023.
//

import Foundation

final class WeatherService {

    private var forecast: ForecastWeatherModel?
    private var futureDays: [List] = []

//    static let shared = WeatherService(forecast: ForecastWeatherModel?)
    init(forecast: ForecastWeatherModel?) {
        self.forecast = forecast
        newDaysArray()
    }

    /// заполнение даты в нужном формате начиная с завтра и т.д.
    func futureDates(indx: Int, timezone: Int, weekDay: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = weekDay ? "dd/MM E" : "dd/MM"
        dateFormatter.timeZone = .gmt
        let today = Calendar.current.date(byAdding: .second, value: timezone, to: .now)
        let nextDate = Calendar.current.date(byAdding: .day, value: indx + 1, to: today!)
        return dateFormatter.string(from: nextDate!)
    }

    /// создание нового массива путём отсечения сеодняшнего дня
    func newDaysArray() {
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
     func forecastTemp(day: Int) -> String {
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
     func averageHumidity(day: Int) -> String {
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
     func commonElementsInArray(stringArray: [String]) -> String {
        let dict = Dictionary(grouping: stringArray, by: {$0})
        let newDict = dict.mapValues({$0.count})
        return newDict.sorted(by: {$0.value > $1.value}).first?.key ?? ""
    }

    /// преобладающее текстовое описание погоды на заданный день
     func primaryDescription(day: Int) -> String {
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
     func primaryIco(day: Int) -> String {
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
