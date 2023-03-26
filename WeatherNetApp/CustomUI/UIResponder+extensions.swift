//
//  UIResponder+extensions.swift
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
            element.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func addArrangedSubviews(stack: UIStackView, elements: [UIView]) {
        for element in elements {
            stack.addArrangedSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
    }


}

