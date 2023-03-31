//
//  MainScreenViewController.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit
import CoreLocation

final class MainScreenWithCollectionView: UIViewController {

    private let whiteView = UIView()

    private let pagingLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        return layout
    }()
    private lazy var pagingCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.pagingLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(CurrentCityCollectionViewCell.self, forCellWithReuseIdentifier: CurrentCityCollectionViewCell.id)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = cities.count
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.preferredIndicatorImage = UIImage(systemName: "circlebadge")
        pageControl.preferredCurrentPageIndicatorImage = UIImage(systemName: "circlebadge.fill")
        pageControl.hidesForSinglePage = true
        pageControl.addTarget(self, action: #selector(pageDidChange), for: .valueChanged)
        return pageControl
    }()

    private let zeroCitiesLabel = UILabel(text: "Добавьте город вручную ⤴︎", font: UIFont(name: Fonts.Rubik.medium.rawValue, size: 24)!, textColor: .white, alignment: .center)

    private var locationManager: CLLocationManager? = nil
    private var currentWeather: CurrentWeatherData?
    private var newCityCurrentWeather: CurrentWeatherData?
//    var currentCity: CityElement?

    private var cities: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.zeroCitiesLabel.isHidden = true
                self.pagingCollectionView.reloadData()
                self.pageControl.numberOfPages = self.cities.count
            }
        }
    }

    init(isGeoTracking: Bool) {
        if isGeoTracking {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager?.pausesLocationUpdatesAutomatically = false
            locationManager?.startUpdatingLocation()
        } else {
            locationManager = nil
        }
//        currentCity = City(name: "", lat: 0, lon: 0, country: "", state: "")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        let apiManager = APImanager.shared
        let lat = locationManager?.location?.coordinate.latitude
        let long = locationManager?.location?.coordinate.longitude

        if locationManager != nil {
            apiManager.getCurrentWeather(latitude: lat ?? 0, longitude: long ?? 0) { weather in
                self.currentWeather = weather
                print("🐱  ", weather.name ?? "no name")
                self.cities.insert(weather.name ?? "no name", at: 0)
                DispatchQueue.main.async {
                    self.pageControl.setIndicatorImage(UIImage(systemName: "location.circle"), forPage: 0)
                    self.pageControl.setCurrentPageIndicatorImage(UIImage(systemName: "location.circle.fill"), forPage: 0)
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationController()

        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
}
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationItem.title = nil
//    }

    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        whiteView.backgroundColor = .white
        let elements = [whiteView, zeroCitiesLabel, pagingCollectionView, pageControl]
        view.addSubviews(to: view, elements: elements)
        enableConstraints(elements: elements)
    }

    private func setupNavigationController() {
        self.navigationItem.title = self.currentWeather?.name ?? "n/d"

        let burgerItem = UIBarButtonItem(image: UIImage(named: "burger"),
                                         style: .plain, target: self,
                                         action: #selector(burgerButtonDidTapp))
        burgerItem.tintColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1)
        burgerItem.width = 34
        navigationItem.leftBarButtonItem = burgerItem
        let geoItem = UIBarButtonItem(image: UIImage(named: "location"),
                                     style: .plain, target: self,
                                     action: #selector(locationButtonDidTapp))
        geoItem.tintColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1333333333, alpha: 1)
        geoItem.width = 20
        navigationItem.rightBarButtonItem = geoItem
    }
//
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteView.topAnchor.constraint(equalTo: view.topAnchor),
            whiteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            pagingCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),//
            pagingCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),//
            pagingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            zeroCitiesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zeroCitiesLabel.topAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: 90)
        ])
    }

    @objc private func burgerButtonDidTapp() {
//        print(self.currentCity.name, self.currentCity.country)
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    @objc private func locationButtonDidTapp() {
        let alertController = UIAlertController(title: "Добавьте город", message: "Введите название", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            let apiManager = APImanager.shared
            guard let cityName = alertController.textFields?.first?.text else {return}
            apiManager.getCityLocation(name: cityName) { searchCity in
                apiManager.getCurrentWeather(latitude: searchCity.lat ?? 0, longitude: searchCity.lon ?? 0) { weather in
                    self.cities.append(searchCity.localNames?["ru"] ?? "--")
                    self.newCityCurrentWeather = weather
                }
            }
            self.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {_ in
            self.dismiss(animated: true)
        }
        alertController.addTextField()
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    @objc private func pageDidChange() {
        let offsetX = UIScreen.main.bounds.width * CGFloat(pageControl.currentPage)
        pagingCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        pageControl.currentPage = Int(pagingCollectionView.contentOffset.x / UIScreen.main.bounds.width)
    }

}

extension MainScreenWithCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCityCollectionViewCell.id, for: indexPath) as? CurrentCityCollectionViewCell {
            cell.detailDelegate = self
            if cities.count == 1 {
                cell.fillCell(currentWeather: currentWeather)
            } else {
                cell.fillCell(currentWeather: newCityCurrentWeather)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
extension MainScreenWithCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    // FIXME: срабатывает раньше времени
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
        navigationItem.title = cities[indexPath.item]
//        print(indexPath.row)
    }
}

extension MainScreenWithCollectionView: DetailDelegate {
    func showSummary() {
        print("peredacha #2")
        let dailySummaryViewController = DailySummaryViewController()
        navigationController?.pushViewController(dailySummaryViewController, animated: true)
    }

    func showDetail() {
        let todayDetailsScreen = TodayDetailsScreen()
        navigationController?.pushViewController(todayDetailsScreen, animated: true)
    }
}

