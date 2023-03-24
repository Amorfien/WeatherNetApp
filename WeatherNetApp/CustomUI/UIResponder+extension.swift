//
//  UIResponder+extension.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 24.03.2023.
//

import UIKit

extension UIResponder {
    func enableConstraints(elements: [UIView]) {
        for element in elements {
            element.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func addSubviews(view: UIView, elements: [UIView]) {

        for element in elements {
            view.addSubview(element)
        }
    }
    func addArrangedSubviews(stack: UIStackView, elements: [UIView]) {
        for element in elements {
            stack.addArrangedSubview(element)
        }
    }


}

