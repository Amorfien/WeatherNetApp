//
//  TodayDetailsScreen.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 27.03.2023.
//

import UIKit

final class TodayDetailsScreen: UIViewController {

//    private let cityLabel = UILabel(text: "Saint-Petersburg, Russia", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 18)!)

    private let detailsLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        return layout
    }()
    private lazy var todayDetailsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.detailsLayout)
        collectionView.backgroundColor = .white
        collectionView.register(ChartViewCell.self, forCellWithReuseIdentifier: ChartViewCell.id)
        collectionView.register(TodayDetailsCollectionViewCell.self, forCellWithReuseIdentifier: TodayDetailsCollectionViewCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private let forecast: ForecastWeatherModel?

    // MARK: - Init
    init(forecast: ForecastWeatherModel?) {
        self.forecast = forecast
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationController()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - UI
    private func setupNavigationController() {
        let title = (forecast?.city?.name ?? "--") + ", " + (forecast?.city?.country ?? "--")
        navigationItem.title = title
        navigationController?.navigationBar.topItem?.backButtonTitle = "Прогноз на 24 часа"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        view.addSubviews(to: view, elements: [todayDetailsCollectionView])
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            todayDetailsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            todayDetailsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todayDetailsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todayDetailsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

// MARK: - Setup collectionView
extension TodayDetailsScreen: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : 8
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartViewCell.id, for: indexPath) as? ChartViewCell {
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayDetailsCollectionViewCell.id, for: indexPath) as? TodayDetailsCollectionViewCell {
                // форматтер для даты
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM"
                dateFormatter.timeZone = .gmt
                let localTime = Date(timeIntervalSince1970: Double((forecast?.list?[indexPath.item].dt)!) + Double((forecast?.city?.timezone)!))
                var date = dateFormatter.string(from: localTime)
                // чтобы даты не прописывались в каждой ячейке
                let dt = forecast?.list?[indexPath.item].dt ?? 0
                let timezone = forecast?.city?.timezone ?? 0
                if indexPath.item != 0 && (dt + timezone) % 86400 > 10800 {
                    date = ""
                }
                // форматтер для времени
                dateFormatter.dateFormat = UserSettings.isTwelve ? "hh:mm a" : "HH:mm"
                let time = dateFormatter.string(from: localTime)
                // основная температура
                let tempCelsium = Int(forecast?.list?[indexPath.item].main?.temp?.rounded() ?? 0)
                let tempFahrenheit = tempCelsium * 9 / 5 + 32
                let temp = UserSettings.isFahrenheit ? tempFahrenheit : tempCelsium
                let tempStr = "\(temp)°"
                // температура по ощущениям
                let feelsLikeCelsium = Int(forecast?.list?[indexPath.item].main?.feelsLike?.rounded() ?? 0)
                let feelsLikeFahrenheit = feelsLikeCelsium * 9 / 5 + 32
                let feelsLike = UserSettings.isFahrenheit ? feelsLikeFahrenheit : feelsLikeCelsium
                let feelsLikeStr = "\(feelsLike)°"
                // скорость ветра и направление
                let windSpeedMeters = forecast?.list?[indexPath.item].wind?.speed?.rounded() // добавить направление
                let windSpeed = UserSettings.isImperial ? 2.237 * (windSpeedMeters ?? 0) : (windSpeedMeters ?? 0)
                let ending = UserSettings.isImperial ? " mph, " : " м/с, "
                var windDirectionStr: String = ""
                if let windDirection = forecast?.list?[indexPath.item].wind?.deg {
                        // упрощённая модель перевода градусов в направление
                        switch windDirection {
                        case 0..<90: windDirectionStr = "СВ"
                        case 90..<180: windDirectionStr = "СЗ"
                        case 180..<270: windDirectionStr = "ЮЗ"
                        default: windDirectionStr = "ЮВ"
                        }
                }
                let windStr = String(Int(windSpeed)) + ending + windDirectionStr
                // влажность
                let humidity = forecast?.list?[indexPath.item].main?.humidity
                let humidityStr = "\(humidity ?? 0)%"
                // облачность
                let clouds = forecast?.list?[indexPath.item].clouds?.all
                let cloudsStr = "\(clouds ?? 0)%"

                let values: [String] = [feelsLikeStr, windStr, humidityStr, cloudsStr]

                cell.fillTodayCell(date: date, time: time, temp: tempStr, values: values)
                return cell
            } else {
                return UICollectionViewCell()
            }
        }
    }
}
extension TodayDetailsScreen: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 172)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 145)
        }
    }
}
