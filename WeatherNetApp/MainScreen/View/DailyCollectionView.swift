//
//  DailyCollectionView.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 25.03.2023.
//

import UIKit

final class DailyCollectionView: UICollectionView {

    let cellHeight: CGFloat = 56
    let inset: CGFloat = 10
    var numberOfCells: CGFloat = 25

    private let dailyLayout = UICollectionViewFlowLayout()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: dailyLayout)
        dailyLayout.sectionInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        register(DailyCollectionViewCell.self, forCellWithReuseIdentifier: DailyCollectionViewCell.id)
        showsVerticalScrollIndicator = false
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DailyCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Int(numberOfCells)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.id, for: indexPath) as? DailyCollectionViewCell {
            cell.fillCell(text: "\(indexPath.item)")
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
extension DailyCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 32, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
