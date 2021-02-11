//
//  AddCityViewController.swift
//  WeatherApp_iOS
//
//  Created by User on 02.02.2021.
//

import Foundation
import UIKit

protocol CitiesDelegate: class{
    func structIsReady()
}
class AddLocationViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CitiesDelegate{
    let cellID="cityCell"
    let cities = AddLocationModel()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    
    func structIsReady() {
        DispatchQueue.main.async{
        self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.cities.getCount() ?? 0
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navVC = (self.parent as! MainNavigationViewController?)
        else {
            return
        }
        self.dismiss(animated: true, completion: {
        (navVC.viewControllers[0] as! ObservedLocationsViewController).addNewLocation(newLocation: self.cities.getAt(index: indexPath.row)!)
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: self.cellID) as! AddCityCell
        let cellData=self.cities.getAt(index: indexPath.row)
        cell.data = .init(name: cellData?.name ?? "", state: cellData?.state ?? "", country: cellData?.country ?? "")
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.cities.setFilter(str: searchText)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cities.cdelegate=self
        self.table.delegate=self
        self.table.dataSource=self
        let addCityCellNib=UINib(nibName: "AddCityCell", bundle: .main)
        self.table.register(addCityCellNib, forCellReuseIdentifier: self.cellID)
        self.searchBar.delegate=self
    }
    
}
