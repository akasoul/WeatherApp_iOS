//
//  LocationsViewController.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 04.02.2021.
//

import Foundation
import UIKit

class ObservedLocationsViewController: UIViewController,UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource, ObservdedLocationsDelegate{
    
    
    @IBOutlet var locationsTable: UITableView!
    @IBOutlet weak var barButtonAddNew: UIBarButtonItem!
    
    private let cellID="ObservedLocationCell"
    private var selectedLocation: location?
    private let model=ObservedLocationsModel()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.locationsTable.dequeueReusableCell(withIdentifier: self.cellID) as! ObservedLocationCell
        let cellData=self.model.getAt(index: indexPath.row)
        let windSpeed = String(cellData.wind?.speed ?? 0)
        let windStr = windSpeed+" m/s"
        cell.data = .init(name: cellData.name!, temperature: cellData.main!.temp!, wind: windStr, weather: UIImage(named: cellData.weather![0].icon!)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            self.model.deleteAt(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loc = self.model.getAt(index: indexPath.row)
        self.selectedLocation = location(id: loc.id ?? 0, name: loc.name ?? "", country: loc.sys!.country ?? "", state: "", coord: location.coordinates(lon: loc.coord!.lon!, lat: loc.coord!.lat!))
        performSegue(withIdentifier: "myseg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "myseg"){
            ((segue.destination as! UITabBarController).viewControllers![0] as! DailyForecastViewController).setLocation(loc: self.selectedLocation!)
            ((segue.destination as! UITabBarController).viewControllers![1] as! ChartsViewController).setLocation(loc: self.selectedLocation!)
        }
    }
    
    func addNewLocation(newLocation: location){
        self.model.addNewLocation(newLocation: newLocation)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.cdelegate=self
        let cellNib=UINib(nibName: "ObservedLocationCell", bundle: .main)
        self.locationsTable.register(cellNib, forCellReuseIdentifier: self.cellID)
        self.locationsTable.delegate=self
        self.locationsTable.dataSource=self
    }
    
    func modelUpdate() {
        DispatchQueue.main.async{
            self.locationsTable.reloadData()
        }
    }
    
    
    
}
