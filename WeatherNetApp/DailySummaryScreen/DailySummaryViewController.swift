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
//        collectionView.backgroundColor = .orange
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    let summaryDayView = SummaryView(isDay: true, "11°", "5 м/с ЗЮЗ", "4 (умеренно)", "55%", "72%")
    let summaryNightView = SummaryView(isDay: false, "7°", "1 м/с ЮЗ", "0", "0%", "30%")

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

    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        scrollView.backgroundColor = .white
        let elements = [scrollView]
        view.addSubviews(to: view, elements: elements)
        scrollView.addSubviews(to: scrollView, elements: [calendarCollectionView, summaryDayView, summaryNightView])
        scrollView.contentSize.height = 1100
    }

    private func setupNavigationController() {
        let secondaryTitle = UIBarButtonItem(title: "Дневная погода")
        secondaryTitle.isEnabled = false
        navigationItem.rightBarButtonItem = secondaryTitle
//        navigationItem.title = "Saint-Petersburg, Russia"
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

extension DailySummaryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        14
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.id, for: indexPath) as? CalendarCollectionViewCell {
//            if indexPath.row == 0 {
////                cell.backgroundColor = .blue
//                cell.isSelected = true
//            }
//            cell.fillCell(index: indexPath.row)
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

    }
}
