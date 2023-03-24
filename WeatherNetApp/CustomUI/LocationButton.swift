//
//  LocationButton.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

final class LocationButton: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.337254902, blue: 0.02745098039, alpha: 1)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.431372549, blue: 0.06666666667, alpha: 1)
        layer.shadowColor = UIColor(red: 0.717, green: 0.319, blue: 0.039, alpha: 0.63).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 45
        layer.shadowOffset = CGSize(width: -5, height: 5)
    }

}
