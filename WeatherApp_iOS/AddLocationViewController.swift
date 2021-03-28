//
//  AddCityViewController.swift
//  WeatherApp_iOS
//
//  Created by User on 02.02.2021.
//

import Foundation
import UIKit

protocol AddLocationListener:class{
    func addNewLocation(newLocation: location)
}

class AddLocationViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AddLocationModelListener{
    let cellID="cityCell"
    let cities = AddLocationModel()
    weak var listener: AddLocationListener?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    
    func modelUpdate() {
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.getCount()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newCity=self.cities.getAt(index: indexPath.row)
        else{
            return
        }
        self.listener?.addNewLocation(newLocation: newCity)
        
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
        self.cities.listener=self
        self.table.delegate=self
        self.table.dataSource=self
        let addCityCellNib=UINib(nibName: "AddCityCell", bundle: .main)
        self.table.register(addCityCellNib, forCellReuseIdentifier: self.cellID)
        self.searchBar.delegate=self
    }
    
}
