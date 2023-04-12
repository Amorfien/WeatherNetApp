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
        return scrollView
    }()

    private let timeline = UIView()
    private let axisXline = UIView()
    private let axisYline = UIView()
    private let timeCount: CGFloat = 40
    private let timeInterval: CGFloat = 50

    private var chartTime: [String] = []
    private var chartRain: [String] = []
    private var chartIco: [String] = []
    private var chartTemp: [Int] = []

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
        axisXline.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        axisYline.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        let elements = [timeline, axisXline, axisYline]
        addSubviews(to: self, elements: [chartScrollView])
        addSubviews(to: chartScrollView, elements: elements)
        chartScrollView.contentSize.width = (timeCount - 1) * timeInterval + 36
    }

    // отрисовка повторяющихся элементов на графике и заполнение их данных
    private func repeatSegment() {

        let tmin = Double(chartTemp.min() ?? 0)
        let tmax = Double(chartTemp.max() ?? 0)
        var percent = 0.0
        let ymax = 152.0
        let ymin = 114.0

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

            /// вычисление диапозона температур и положения точки на графике
            let tcur = Double(chartTemp[indx])
            percent = (tcur - tmin)/(tmax - tmin + 0.01) // чтобы случайно не поделить на ноль
            let yaxis = percent * (ymax - ymin) + ymin

            addSubviews(to: chartScrollView, elements: [rect, timeLabel, rainLabel, icoView, tempLabel, circle])
            NSLayoutConstraint.activate([
                rect.widthAnchor.constraint(equalToConstant: 4),
                rect.heightAnchor.constraint(equalToConstant: 8),
                rect.leadingAnchor.constraint(equalTo: timeline.leadingAnchor, constant: CGFloat(indx) * timeInterval),
                rect.centerYAnchor.constraint(equalTo: timeline.centerYAnchor),
                timeLabel.leadingAnchor.constraint(equalTo: chartScrollView.leadingAnchor, constant: CGFloat(indx) * timeInterval),
                timeLabel.topAnchor.constraint(equalTo: timeline.bottomAnchor, constant: 12),
                rainLabel.leadingAnchor.constraint(equalTo: chartScrollView.leadingAnchor, constant: CGFloat(indx) * timeInterval + 12),
                rainLabel.bottomAnchor.constraint(equalTo: timeline.topAnchor, constant: -12),
                icoView.leadingAnchor.constraint(equalTo: chartScrollView.leadingAnchor, constant: CGFloat(indx) * timeInterval + 10),
                icoView.bottomAnchor.constraint(equalTo: rainLabel.topAnchor, constant: -4),
                icoView.heightAnchor.constraint(equalToConstant: 18),

                circle.centerXAnchor.constraint(equalTo: timeline.leadingAnchor, constant: CGFloat(indx) * timeInterval),
                circle.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yaxis),
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

            timeline.leadingAnchor.constraint(equalTo:  chartScrollView.leadingAnchor, constant: 18),
            timeline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56),
            timeline.widthAnchor.constraint(equalToConstant: (timeCount - 1) * timeInterval),
            timeline.heightAnchor.constraint(equalToConstant: 1),

            axisXline.leadingAnchor.constraint(equalTo:  chartScrollView.leadingAnchor, constant: 18),
            axisXline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -114),
            axisXline.widthAnchor.constraint(equalToConstant: (timeCount - 1) * timeInterval),
            axisXline.heightAnchor.constraint(equalToConstant: 0.3),

            axisYline.leadingAnchor.constraint(equalTo: axisXline.leadingAnchor, constant: -3),
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
        repeatSegment()

//        chartScrollView.layer.addSublayer(chartDraw(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 50, y: 50)))//

    }

    /// пробую соединить точки на графике
    private func chartDraw(start: CGPoint, end: CGPoint) -> CAShapeLayer {

        let chartPath = UIBezierPath()
        chartPath.move(to: start)
        chartPath.addLine(to: end)
//        chartPath.close()

        let layer = CAShapeLayer()
        layer.path = chartPath.cgPath
        layer.strokeColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1).cgColor
        layer.lineWidth = 2
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }


}
