//
//  MainScreenViewController.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

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
        collectionView.backgroundColor = .white
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
        pageControl.addTarget(self, action: #selector(pageDidChange), for: .valueChanged)
        return pageControl
    }()

    private let cities = ["Saint-Petersburg", "Moscow", "New-York", "London"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationController()

        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationItem.title = nil
//    }

    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        whiteView.backgroundColor = .white
        let elements = [whiteView, pagingCollectionView, pageControl]
        view.addSubviews(to: view, elements: elements)
        enableConstraints(elements: elements)
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
//        print(indexPath.row)
    }
}

extension MainScreenWithCollectionView: DetailDelegate {
    func showDetail() {
        let todayDetailsScreen = TodayDetailsScreen()
        navigationController?.pushViewController(todayDetailsScreen, animated: true)
    }
}

