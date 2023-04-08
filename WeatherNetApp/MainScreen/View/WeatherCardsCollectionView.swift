//
//  WeatherCardsCollectionView.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 25.03.2023.
//

import UIKit

final class WeatherCardsCollectionView: UICollectionView {

    private let weatherCardsLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()

    var coordinates: (Double, Double, Double) = (0, 0, 0) {
        didSet {
            APImanager.shared.get5dayForecast(latitude: coordinates.0, longitude: coordinates.1) { forecast in
                self.forecastList = forecast.list
                DispatchQueue.main.async {
                    self.reloadData()
                }
            }
        }
    }
    private var forecastList: [List]?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: weatherCardsLayout)
        register(WeatherCardCell.self, forCellWithReuseIdentifier: WeatherCardCell.id)
        showsHorizontalScrollIndicator = false
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension WeatherCardsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        40
        self.forecastList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCardCell.id, for: indexPath) as? WeatherCardCell {
            guard let tempCelsium = forecastList?[indexPath.item].main?.temp else { return cell }
            let tempFahrenheit = tempCelsium * 9 / 5 + 32
            let ico = forecastList?[indexPath.item].weather?.first?.icon
            let icoName = ImageDictionary.dictionary[ico ?? "noIco"]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = UserSettings.isTwelve ? "hh:mm" : "HH:mm"
            dateFormatter.timeZone = .gmt
            let time = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval((forecastList?[indexPath.item].dt)! + Int(coordinates.2))))
            cell.fillCardCell(temp: UserSettings.isFahrenheit ? tempFahrenheit : tempCelsium, ico: icoName, time: time)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
extension WeatherCardsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 42, height: 84)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
