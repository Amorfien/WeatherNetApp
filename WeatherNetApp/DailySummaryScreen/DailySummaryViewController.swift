//
//  DailySummaryViewController.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 28.03.2023.
//

import UIKit

final class DailySummaryViewController: UIViewController {

    let scrollView = UIScrollView()

    private let caledarLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }()
    private lazy var calendarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.caledarLayout)
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.id)
//        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    var summaryDayView = SummaryView(isDay: true, "11°", "5 м/с ЗЮЗ", "4 (умеренно)", "55%", "72%")
    let summaryNightView = SummaryView(isDay: false, "7°", "1 м/с ЮЗ", "0", "0%", "30%")

    private let forecast: ForecastWeatherModel?
    private let dayIndex: Int

    // MARK: - Init
    init(forecast: ForecastWeatherModel?, dayIndex: Int) {
        self.forecast = forecast
        self.dayIndex = dayIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationController()
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        scrollView.backgroundColor = .white
        let elements = [scrollView]
        view.addSubviews(to: view, elements: elements)
        scrollView.addSubviews(to: scrollView, elements: [calendarCollectionView, summaryDayView, summaryNightView])
        scrollView.contentSize.height = 1100
        fillDayView(viewCard: summaryDayView)
        fillDayView(viewCard: summaryNightView)
    }

    private func fillDayView(viewCard: SummaryView) {
        let values = ["1", "2", "3", "4", "5"]
        summaryDayView = SummaryView(isDay: true, values[0], values[1], values[2], values[3], values[4])
        viewCard.fillDayView(ico: "snowflake", temp: "99°", values: values)
    }

    private func setupNavigationController() {
        let title = (forecast?.city?.name ?? "--") + ", " + (forecast?.city?.country ?? "--")
        navigationItem.title = title
        navigationController?.navigationBar.topItem?.backButtonTitle = "Дневная погода"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            calendarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            calendarCollectionView.heightAnchor.constraint(equalToConstant: 50),

            summaryDayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryDayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryDayView.topAnchor.constraint(equalTo: calendarCollectionView.bottomAnchor, constant: 40),
            summaryDayView.heightAnchor.constraint(equalToConstant: 340),

            summaryNightView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryNightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryNightView.topAnchor.constraint(equalTo: summaryDayView.bottomAnchor, constant: 12),
            summaryNightView.heightAnchor.constraint(equalToConstant: 340),

        ])
    }
}

// MARK: - Setup collectionView
extension DailySummaryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        14
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.id, for: indexPath) as? CalendarCollectionViewCell {
            // select нужной даты
            if indexPath.item == dayIndex {
                collectionView.selectItem(at: IndexPath(item: dayIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }

            let weatherService = WeatherService(forecast: forecast)
            let futureDate = weatherService.futureDates(indx: indexPath.item, timezone: forecast?.city?.timezone ?? 0, weekDay: true)

            cell.fillCalendarCell(date: futureDate)

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
extension DailySummaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 88, height: 36)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select ", indexPath.item)
    }
}
