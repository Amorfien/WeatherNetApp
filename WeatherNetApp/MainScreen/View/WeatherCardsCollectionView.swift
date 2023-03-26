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

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: weatherCardsLayout)
//        backgroundColor = .orange
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
        12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCardCell.id, for: indexPath) as? WeatherCardCell {
            cell.fillCell(index: indexPath.row)
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
