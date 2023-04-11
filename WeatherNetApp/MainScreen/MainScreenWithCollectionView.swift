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

    private var cities: [CurrentWeatherModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.pageControl.numberOfPages = self.cities.count
                // меняем индикатор первого города, если он определен по геолокации
                if self.locationManager != nil {
                    self.pageControl.setIndicatorImage(UIImage(systemName: "location.circle"), forPage: 0)
                    self.pageControl.setCurrentPageIndicatorImage(UIImage(systemName: "location.circle.fill"), forPage: 0)
                }
                // ограничение количества городов - 10шт
                self.navigationItem.rightBarButtonItems?[0].isEnabled = self.cities.count == 10 ? false : true
            }
        }
    }
    private var forecasts: [ForecastWeatherModel] = []

    // MARK: - Init
    init(isGeoTracking: Bool) {
        if isGeoTracking {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager?.pausesLocationUpdatesAutomatically = false
            locationManager?.startUpdatingLocation()
        } else {
            locationManager = nil
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let locationManager {
            APImanager.shared.getInfoByCoord(latitude: locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0) { current, forecast in
                self.forecasts.append(forecast)
                self.cities.append(current)
                DispatchQueue.main.async {
                    self.reloading()
                    self.pageControl.setIndicatorImage(UIImage(systemName: "location.circle"), forPage: 0)
                    self.pageControl.setCurrentPageIndicatorImage(UIImage(systemName: "location.circle.fill"), forPage: 0)
                }
            }

        }

        setupUI()
        setupNavigationController()

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pagingCollectionView.reloadData()
    }


    // MARK: - NavigationController
    private func setupNavigationController() {
//        self.navigationItem.title = self.cities[pageControl.currentPage].name

        navigationController?.navigationBar.tintColor = .darkText

        let burgerItem = UIBarButtonItem(image: UIImage(systemName: "text.justify.trailing"),
                                         style: .plain, target: self,
                                         action: #selector(burgerButtonDidTapp))
        navigationItem.leftBarButtonItem = burgerItem
        let geoItem = UIBarButtonItem(image: UIImage(systemName: "location.magnifyingglass"),
                                     style: .plain, target: self,
                                     action: #selector(locationButtonDidTapp))
        let cityList = UIBarButtonItem(image: UIImage(systemName: "list.bullet.circle"),
                                     style: .plain, target: self,
                                     action: #selector(cityListButtonDidTapp))
        cityList.isEnabled = false
        navigationItem.rightBarButtonItems = [geoItem, cityList]
    }


    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        whiteView.backgroundColor = .white
        let elements = [whiteView, zeroCitiesLabel, pagingCollectionView, pageControl]
        view.addSubviews(to: view, elements: elements)
        enableConstraints(elements: elements)
    }

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
            zeroCitiesLabel.topAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: 60)
        ])
    }

    // MARK: - Reloading
    private func reloading() {
        self.pagingCollectionView.reloadData()

        self.pageControl.numberOfPages = self.cities.count
        if self.cities.count > 0 {
            self.zeroCitiesLabel.isHidden = true
            self.navigationItem.rightBarButtonItems?[1].isEnabled = true
        } else {
            self.zeroCitiesLabel.isHidden = false
            self.navigationItem.title = nil
            self.navigationItem.rightBarButtonItems?[1].isEnabled = false
        }
    }

    // MARK: - Buttons actions
    @objc private func burgerButtonDidTapp() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    @objc private func locationButtonDidTapp() {
        let alertController = UIAlertController(title: "Добавьте город", message: "Введите название", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in

            guard let cityName = alertController.textFields?.first?.text else { return }
            APImanager.shared.getInfoByName(cityName: cityName) { current, forecast in
                for city in self.cities {
                    if city.id == current.id { return } // проверка на одинаковые города
                }
                self.forecasts.append(forecast)
                self.cities.append(current)
                DispatchQueue.main.async {
                    self.reloading()
                    self.selectCity(index: self.cities.count - 1) // перескок на добавленный город
                }
            }
            self.dismiss(animated: true)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {_ in
            self.dismiss(animated: true)
        }
        alertController.addTextField()
        alertController.textFields?.first?.delegate = self
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    @objc private func cityListButtonDidTapp() {
        let cityListVC = CityListViewController()
        cityListVC.cityListDelegate = self
        for city in cities {
            let temp = Int(city.main?.temp?.rounded() ?? 0)
            cityListVC.cityList.append((city.name ?? "--", temp))
        }
        if let sheet = cityListVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        if locationManager != nil {
            cityListVC.firstCityIsTracking = true
        }
        present(cityListVC, animated: true)
    }

    @objc private func pageDidChange() {
        let offsetX = UIScreen.main.bounds.width * CGFloat(pageControl.currentPage)
        pagingCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        pageControl.currentPage = Int(pagingCollectionView.contentOffset.x / UIScreen.main.bounds.width)
    }

}

// MARK: - Setup collectionview
extension MainScreenWithCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCityCollectionViewCell.id, for: indexPath) as? CurrentCityCollectionViewCell {
            cell.fillCityCell(currentWeather: cities[indexPath.item], forecast: forecasts[indexPath.item])
            cell.detailDelegate = self
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
        let title = (cities[indexPath.item].name ?? "--") + ", " + (cities[indexPath.item].sys?.country ?? "--")
        navigationItem.title = title
        if locationManager != nil && indexPath.item == 0 {
            navigationItem.title = "⦿ " + title
        }
    }
}

// MARK: - Delegate methods
extension MainScreenWithCollectionView: DetailDelegate {
    func showSummary(forecast: ForecastWeatherModel?, indx: Int) {
        print("peredacha #2, index = \(indx)")
        let dailySummaryViewController = DailySummaryViewController(forecast: forecast, dayIndex: indx)
        navigationController?.pushViewController(dailySummaryViewController, animated: true)
    }

    func showDetail(forecast: ForecastWeatherModel?) {
        let todayDetailsScreen = TodayDetailsScreen(forecast: forecast)
        navigationController?.pushViewController(todayDetailsScreen, animated: true)
    }
}

extension MainScreenWithCollectionView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension MainScreenWithCollectionView: CityListProtocol {
    func selectCity(index: Int) {
        pageControl.currentPage = index
        let offsetX = UIScreen.main.bounds.width * CGFloat(self.pageControl.currentPage)
        self.pagingCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    func deleteCity(index: Int) {
        cities.remove(at: index)
        forecasts.remove(at: index)
        reloading()
    }
}
