//
//  MainScreenViewController.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

final class MainScreenViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
//        scrollView.
        return scrollView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
//        pageControl.
        return pageControl
    }()

    private let dailyView = DailyView()
    private let detailButton = UIButton(underlined: "Подробнее на 24 часа")

    private let weatherCardsCollectionView = WeatherCardsCollectionView()

    private let stackView = UIStackView()
    private let dailyLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Rubik.medium.rawValue, size: 18)
        label.text = "Ежедневный прогноз"
        return label
    }()
    private let moreDaysButton = UIButton(underlined: "25 дней")

    private let dailyCollectionView = DailyCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        let elements = [pageControl, scrollView, dailyView, detailButton, weatherCardsCollectionView, stackView, dailyLable, moreDaysButton, dailyCollectionView]
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        scrollView.addSubviews(view: scrollView, elements: [dailyView, detailButton, weatherCardsCollectionView, stackView, dailyCollectionView])
        stackView.addArrangedSubviews(stack: stackView, elements: [dailyLable, moreDaysButton])
        enableConstraints(elements: elements)
        setupNavigationController()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var contentRect = CGRect.zero
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        scrollView.contentSize.height = contentRect.maxY
    }


    private func setupNavigationController() {
        navigationItem.title = "Saint-Petersburg"
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

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            dailyView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            dailyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dailyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dailyView.heightAnchor.constraint(equalToConstant: 212),

            detailButton.topAnchor.constraint(equalTo: dailyView.bottomAnchor, constant: 28),
            detailButton.trailingAnchor.constraint(equalTo: dailyView.trailingAnchor),

//            weatherCardsCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            weatherCardsCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            weatherCardsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            weatherCardsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherCardsCollectionView.topAnchor.constraint(equalTo: detailButton.bottomAnchor, constant: 24),
            weatherCardsCollectionView.heightAnchor.constraint(equalToConstant: 85),

            stackView.topAnchor.constraint(equalTo: weatherCardsCollectionView.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: dailyView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: dailyView.trailingAnchor),

            dailyCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            dailyCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            dailyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyCollectionView.heightAnchor.constraint(equalToConstant: dailyCollectionView.numberOfCells * (dailyCollectionView.cellHeight + dailyCollectionView.inset) + dailyCollectionView.inset)
//            dailyCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)

        ])
    }

    @objc private func burgerButtonDidTapp() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    @objc private func locationButtonDidTapp() {
        let alertController = UIAlertController(title: "Добавьте город", message: "Введите название", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            self.navigationController?.pushViewController(OnboardingViewController(), animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {_ in
            self.dismiss(animated: true)
        }
        alertController.addTextField()
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

}
