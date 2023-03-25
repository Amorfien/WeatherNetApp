//
//  DailyView.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

final class DailyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        layer.cornerRadius = 5

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
