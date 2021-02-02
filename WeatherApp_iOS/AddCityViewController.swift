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
class AddCityViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CitiesDelegate{
    let cellID="cityCell"
    let cities = Cities()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    
    func structIsReady() {
        print("struct is ready")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        let cell = self.table.dequeueReusableCell(withIdentifier: self.cellID)!
        cell.textLabel!.text=self.cities.getAt(index: indexPath.row)!.name!
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cities.cdelegate=self
        
        self.table.delegate=self
        self.table.dataSource=self
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        
    }
    
}
