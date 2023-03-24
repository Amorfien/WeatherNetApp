//
//  SettingsStack.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

final class SettingsStack: UIStackView {

//    private let segmentedControl: UISegmentedControl = {
//        let segment = UISegmentedControl(items: [leftSegment, "78"])
//
//        return segment
//    }()
    let titleLabel = UILabel()
    var segmentedControl = UISegmentedControl()

    init(title: String, leftSegment: String, rightSegment: String, selected: Int) {
        super.init(frame: .zero)
        titleLabel.text = title
        titleLabel.font = UIFont(name: "RubikRoman-Regular", size: 16)
        titleLabel.textColor = #colorLiteral(red: 0.6039215686, green: 0.5882352941, blue: 0.5882352941, alpha: 1)
        segmentedControl = UISegmentedControl(items: [leftSegment, rightSegment])
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        segmentedControl.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9294117647, blue: 0.9137254902, alpha: 1)
        segmentedControl.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.9139999747, green: 0.9330000281, blue: 0.9800000191, alpha: 1)], for: .selected)
        segmentedControl.selectedSegmentIndex = selected
        let elements = [titleLabel, segmentedControl]
        addArrangedSubviews(stack: self, elements: elements)
        enableConstraints(elements: elements)
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.widthAnchor.constraint(equalToConstant: 80),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }


}
