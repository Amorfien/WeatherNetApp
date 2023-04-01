//
//  CityListViewController.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 01.04.2023.
//

import UIKit

protocol DeleteCityProtocol: AnyObject {
    func deleteCity(index: Int)
}

final class CityListViewController: UIViewController {

    private lazy var cityListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1).withAlphaComponent(0.95)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    var cityList = [String]()

    weak var deleteCityDelegate: DeleteCityProtocol?

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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .white.withAlphaComponent(0.75)
        cell.textLabel?.text = cityList[indexPath.section]
        return cell
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Список добавленных городов:"
//        } else {
//            return nil
//        }
//    }
}
extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить"
        ) { _, _, _ in
//            let post = self.favoritesPosts[indexPath.row]
//            self.coreDataServiceLite.deletePost(predicate: NSPredicate(format: "id == %ld", post.id))
            self.deleteCityDelegate?.deleteCity(index: indexPath.section)
            self.cityList.remove(at: indexPath.section)
            self.cityListTableView.deleteSections([indexPath.section], with: .right)
            if self.cityList.count == 0 {
                self.dismiss(animated: true)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }


}
