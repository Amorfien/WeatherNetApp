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

    /// получение только дневной или только ночной температуры
    func halfDayTemp(day: Int, isNight: Bool) -> String {
        guard futureDays.count > ((day + 1) * 8) else {
            return "??°"
        }
        let needDay = [List](futureDays[(8 * day) ..< (8 * (day + 1))])
        let temp = isNight ? needDay[1].main?.temp : needDay[5].main?.temp
        let celsium = Int(temp?.rounded() ?? 0)
        let fahrenheit = celsium * 9 / 5 + 32

        return UserSettings.isFahrenheit ? "\(fahrenheit)°" : "\(celsium)°"
    }
    /// получение только дневной или только ночной иконки
    func halfDayIco(day: Int, isNight: Bool) -> String {
        guard futureDays.count > ((day + 1) * 8) else {
            return "fog"
        }
        let needDay = [List](futureDays[(8 * day) ..< (8 * (day + 1))])
        let ico = isNight ? needDay[1].weather?.first?.icon : needDay[5].weather?.first?.icon

        return ico ?? "fog"
    }
    /// получение только дневного или только ночного описания
    func halfDayDesc(day: Int, isNight: Bool) -> String {
        guard futureDays.count > ((day + 1) * 8) else {
            return "?no data?"
        }
        let needDay = [List](futureDays[(8 * day) ..< (8 * (day + 1))])
        let desc = needDay[isNight ? 1 : 0].weather?.first?.description?.capitalizingFirstLetter()

        return desc ?? "?no data?"
    }

    /// получение только дневной или только ночной иконки
    func halfDayValue(valueType: WeatherStackType, day: Int, isNight: Bool) -> String {
        guard futureDays.count > ((day + 1) * 8) else {
            return "??"
        }
        let needDay = [List](futureDays[(8 * day) ..< (8 * (day + 1))])
        var result = ""
        switch valueType {
        case .temp:
            let temp = isNight ? needDay[1].main?.feelsLike : needDay[5].main?.feelsLike
            let celsium = Int(temp?.rounded() ?? 0)
            let fahrenheit = celsium * 9 / 5 + 32
            result = UserSettings.isFahrenheit ? "\(fahrenheit)°" : "\(celsium)°"
        case .wind:
            let wind = isNight ? needDay[1].wind?.speed : needDay[5].wind?.speed
            let windSpeed = UserSettings.isImperial ? 2.237 * (wind?.rounded() ?? 0) : (wind?.rounded() ?? 0)
            let ending = UserSettings.isImperial ? " mph, " : " м/с, "
            var windDirectionStr: String = ""
            if let windDirection = needDay[isNight ? 1 : 5].wind?.deg {
                    // упрощённая модель перевода градусов в направление
                    switch windDirection {
                    case 0..<90: windDirectionStr = "СВ"
                    case 90..<180: windDirectionStr = "СЗ"
                    case 180..<270: windDirectionStr = "ЮЗ"
                    default: windDirectionStr = "ЮВ"
                    }
            }
//            let windStr = String(Int(windSpeed)) + ending + windDirectionStr
            result = String(Int(windSpeed)) + ending + windDirectionStr
        case .ultraviolet:
            let visible = isNight ? needDay[1].visibility : needDay[5].visibility
            let distance = UserSettings.isImperial ? (visible ?? 1613) / 1613 : (visible ?? 1000) / 1000
            result = String(distance) + (UserSettings.isImperial ? " миль" : " км")
        case .rainfall:
            let hum = isNight ? needDay[1].main?.humidity : needDay[5].main?.humidity
            result = "\(hum ?? 0)%"
        case .cloud:
            let cloud = isNight ? needDay[1].clouds?.all : needDay[5].clouds?.all
            result = "\(cloud ?? 0)%"
        }

        return result
    }

}
