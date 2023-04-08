//
//  CityListViewController.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 01.04.2023.
//

import UIKit

protocol CityListProtocol: AnyObject {
    func selectCity(index: Int)
    func deleteCity(index: Int)
}

final class CityListViewController: UIViewController {

    private lazy var cityListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityList")
        tableView.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1).withAlphaComponent(0.95)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    var cityList = [(String, Int)]()

    var firstCityIsTracking: Bool = false

    weak var cityListDelegate: CityListProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = cityListTableView
    }

}

extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        cityList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "CityList")
        cell.layer.borderWidth = 1
        cell.backgroundColor = .white.withAlphaComponent(0.75)
        cell.textLabel?.text = cityList[indexPath.section].0
        let temp = cityList[indexPath.section].1
        if temp > 0 {
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            cell.detailTextLabel?.text = "+\(temp)°"
        } else {
            cell.detailTextLabel?.textColor = temp == 0 ? .black : .systemRed
            cell.detailTextLabel?.text = "\(temp)°"
        }
        if self.firstCityIsTracking && indexPath.section == 0 {
            cell.imageView?.image = UIImage(systemName: "location")
        }
        return cell
    }

}
extension CityListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cityListDelegate?.selectCity(index: indexPath.section)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.firstCityIsTracking && indexPath.section == 0 {
            return nil
        } else {
            let deleteAction = UIContextualAction(
                style: .destructive,
                title: "Удалить"
            ) { _, _, _ in
                //            let post = self.favoritesPosts[indexPath.row]
                //            self.coreDataServiceLite.deletePost(predicate: NSPredicate(format: "id == %ld", post.id))
                
                self.cityListDelegate?.deleteCity(index: indexPath.section)
                self.cityList.remove(at: indexPath.section)
                self.cityListTableView.deleteSections([indexPath.section], with: .right)
                if self.cityList.count == 0 {
                    self.dismiss(animated: true)
                }
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }

}
