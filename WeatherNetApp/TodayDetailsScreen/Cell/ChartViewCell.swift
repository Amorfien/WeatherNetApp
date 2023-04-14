//
//  ChartViewCell.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 27.03.2023.
//

import UIKit

final class ChartViewCell: UICollectionViewCell {

    static let id = "ChartViewCell"

    private let chartScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = #colorLiteral(red: 0.9139999747, green: 0.9330000281, blue: 0.9800000191, alpha: 1)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let timeline = UIView()
    private let axisXline = UIView()
    private let axisYline = UIView()
    private let timeCount: CGFloat = 40
    private let timeInterval: CGFloat = 50
    private let edge: CGFloat = 24

    private var chartTime: [String] = []
    private var chartRain: [String] = []
    private var chartIco: [String] = []
    private var chartTemp: [Int] = [] {
        didSet {
            tmin = Double(chartTemp.min() ?? 0)
            tmax = Double(chartTemp.max() ?? 0)
        }
    }

    private var tmin = 0.0
    private var tmax = 0.0
    private var percent = 0.0
    private let ymax = 152.0
    private let ymin = 110.0

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupView() {
        backgroundColor = .white
        timeline.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
        axisXline.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        axisYline.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let elements = [timeline, axisXline, axisYline]
        addSubviews(to: self, elements: [chartScrollView])
        addSubviews(to: chartScrollView, elements: elements)
        chartScrollView.contentSize.width = (timeCount - 1) * timeInterval + 48
    }

    // отрисовка повторяющихся элементов на графике и заполнение их данных
    private func repeatSegment() {

        for indx in 0..<Int(timeCount) {
            let rect = UIView()
            rect.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
            let circle = UIView()
            circle.backgroundColor = .white
            circle.layer.cornerRadius = 5
            circle.layer.borderWidth = 0.5
            let timeLabel = UILabel(text: self.chartTime[indx], font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)!, alignment: .center)
            let rainLabel = UILabel(text: self.chartRain[indx], font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 12)!, alignment: .center)
            let icoView = UIImageView(image: UIImage(named: self.chartIco[indx]))
            icoView.contentMode = .scaleAspectFit
            let tempLabel = UILabel(text: "\(self.chartTemp[indx])°", font: UIFont(name: Fonts.Rubik.regular.rawValue, size: 14)!, alignment: .center)

            addSubviews(to: chartScrollView, elements: [rect, timeLabel, rainLabel, icoView, tempLabel, circle])
            NSLayoutConstraint.activate([
                rect.widthAnchor.constraint(equalToConstant: 4),
                rect.heightAnchor.constraint(equalToConstant: 8),
                rect.leadingAnchor.constraint(equalTo: timeline.leadingAnchor, constant: CGFloat(indx) * timeInterval),
                rect.centerYAnchor.constraint(equalTo: timeline.centerYAnchor),
                timeLabel.leadingAnchor.constraint(equalTo: chartScrollView.leadingAnchor, constant: CGFloat(indx) * timeInterval + 6),
                timeLabel.topAnchor.constraint(equalTo: timeline.bottomAnchor, constant: 12),
                rainLabel.leadingAnchor.constraint(equalTo: chartScrollView.leadingAnchor, constant: CGFloat(indx) * timeInterval + 18),
                rainLabel.bottomAnchor.constraint(equalTo: timeline.topAnchor, constant: -10),
                icoView.leadingAnchor.constraint(equalTo: chartScrollView.leadingAnchor, constant: CGFloat(indx) * timeInterval + 16),
                icoView.bottomAnchor.constraint(equalTo: rainLabel.topAnchor, constant: -4),
                icoView.heightAnchor.constraint(equalToConstant: 18),

                circle.centerXAnchor.constraint(equalTo: timeline.leadingAnchor, constant: CGFloat(indx) * timeInterval),
                circle.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yCalc(temp: chartTemp[indx])),
                circle.widthAnchor.constraint(equalToConstant: 6),
                circle.heightAnchor.constraint(equalToConstant: 6),
                tempLabel.leadingAnchor.constraint(equalTo: timeline.leadingAnchor, constant: CGFloat(indx) * timeInterval),
                tempLabel.bottomAnchor.constraint(equalTo: circle.topAnchor, constant: 2)
            ])
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chartScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartScrollView.topAnchor.constraint(equalTo: topAnchor),
            chartScrollView.heightAnchor.constraint(equalToConstant: 152),

            timeline.leadingAnchor.constraint(equalTo:  chartScrollView.leadingAnchor, constant: edge),
            timeline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56),
            timeline.widthAnchor.constraint(equalToConstant: (timeCount - 1) * timeInterval),
            timeline.heightAnchor.constraint(equalToConstant: 1),

            axisXline.leadingAnchor.constraint(equalTo:  chartScrollView.leadingAnchor, constant: edge),
            axisXline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ymin + 2.5),
            axisXline.widthAnchor.constraint(equalToConstant: (timeCount - 1) * timeInterval + 4),
            axisXline.heightAnchor.constraint(equalToConstant: 0.3),

            axisYline.leadingAnchor.constraint(equalTo: axisXline.leadingAnchor, constant: -1),
            axisYline.bottomAnchor.constraint(equalTo: axisXline.topAnchor),
            axisYline.widthAnchor.constraint(equalToConstant: 0.3),
            axisYline.heightAnchor.constraint(equalToConstant: 38)
        ])
    }

    // MARK: - public method
    func fillChartCell(time: [String], rain: [String], ico: [String], temp: [Int]) {
        self.chartTime = time
        self.chartRain = rain
        self.chartIco = ico
        self.chartTemp = temp

        chartScrollView.layer.addSublayer(chartDraw()[1])
        chartScrollView.layer.addSublayer(chartDraw()[0])
        repeatSegment()
    }

    /// пробую соединить точки на графике
    private func chartDraw() -> [CAShapeLayer] {

        let chartPath = UIBezierPath()
//        chartPath.move(to: CGPoint(x: 24, y: 172 - ymin))
        chartPath.move(to: CGPoint(x: 24, y: 172 - Int(yCalc(temp: chartTemp[0]))))
        for (i, temp) in chartTemp.enumerated() {
            chartPath.addLine(to: CGPoint(x: i * Int(timeInterval) + 24, y: 171 - Int(yCalc(temp: temp))))
        }

        let chartLayer = CAShapeLayer()
        chartLayer.path = chartPath.cgPath
        chartLayer.strokeColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1).cgColor
        chartLayer.lineWidth = 1.0
        chartLayer.fillColor = UIColor.clear.cgColor

        chartPath.addLine(to: CGPoint(x: 39 * Int(timeInterval) + 24, y: 172 - Int(ymin) + 2))
        chartPath.addLine(to: CGPoint(x: 24, y: 172 - ymin + 2))
        chartPath.close()

        let fillLayer = CAShapeLayer()
        fillLayer.path = chartPath.cgPath
        fillLayer.fillColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
        return [chartLayer, fillLayer]
    }
    /// вычисление диапозона температур и положения точки на графике
    private func yCalc(temp: Int) -> Double {
        if tmax != tmin {
            percent = (Double(temp) - tmin)/(tmax - tmin) // чтобы случайно не поделить на ноль
        }
        let yaxis = percent * (ymax - ymin) + ymin
        return yaxis
    }

}
