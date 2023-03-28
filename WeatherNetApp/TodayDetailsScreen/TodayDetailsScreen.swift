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

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationController()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationController()
    }

    private func setupNavigationController() {
        let secondaryTitle = UIBarButtonItem(title: "Прогноз на 24 часа")
        secondaryTitle.isEnabled = false
        navigationItem.rightBarButtonItem = secondaryTitle
        navigationItem.title = "Saint-Petersburg, Russia"
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

extension TodayDetailsScreen: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
        default: return 8
        }
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
