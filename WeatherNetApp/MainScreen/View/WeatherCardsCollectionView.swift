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

    private var forecast: ForecastWeatherModel? {
        didSet {
            self.reloadData()
        }
    }

    // MARK: - Init
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

    // MARK: - public method
    func fillCardsCollection(forecast: ForecastWeatherModel?) {
        self.forecast = forecast
    }

}

// MARK: - setup collectionview
extension WeatherCardsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.forecast?.list?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCardCell.id, for: indexPath) as? WeatherCardCell {
            guard let tempCelsium = forecast?.list?[indexPath.item].main?.temp else { return cell }
            let tempFahrenheit = tempCelsium * 9 / 5 + 32
            let ico = forecast?.list?[indexPath.item].weather?.first?.icon
            let icoName = ImageDictionary.dictionary[ico ?? "noIco"]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = UserSettings.isTwelve ? "hh:mm" : "HH:mm"
            dateFormatter.timeZone = .gmt
            let localTime = Date(timeIntervalSince1970: Double((forecast?.list?[indexPath.item].dt)!) + Double((forecast?.city?.timezone)!))
            let time = dateFormatter.string(from: localTime)
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
