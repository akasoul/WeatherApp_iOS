//
//  LocationsViewController.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 04.02.2021.
//

import Foundation
import UIKit

class ObservedLocationsViewController: UITableViewController,UINavigationBarDelegate,ObservdedLocationsDelegate{

    
    @IBOutlet var locationsTable: UITableView!
    @IBOutlet weak var barButtonAddNew: UIBarButtonItem!
    let cellID="ObservedLocationCell"
    
    private var selectedLocation: location?
    private let weatherInLocations=ObservedLocationsModel()
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherInLocations.getCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.locationsTable.dequeueReusableCell(withIdentifier: self.cellID) as! ObservedLocationCell
        let cellData=self.weatherInLocations.getAt(index: indexPath.row)
        let windSpeed = String(cellData.wind?.speed ?? 0)
        //let windDeg = String(cellData.wind!.deg!)
        let windStr = windSpeed+" m/s"
        cell.data = .init(name: cellData.name!, temperature: cellData.main!.temp!, wind: windStr, weather: UIImage(named: cellData.weather![0].icon!)!)
        //let cellData=self.cities.getAt(index: indexPath.row)
        //cell.data = .init(name: cellData?.name ?? "", state: cellData?.state ?? "", country: cellData?.country ?? "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            self.weatherInLocations.deleteAt(index: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loc = self.weatherInLocations.getAt(index: indexPath.row)
        self.selectedLocation = location(id: loc.id ?? 0, name: loc.name ?? "", country: loc.sys!.country ?? "", state: "", coord: location.coordinates(lon: loc.coord!.lon!, lat: loc.coord!.lat!))
        performSegue(withIdentifier: "myseg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "myseg"){
        ((segue.destination as! UITabBarController).viewControllers![0] as! DailyForecastViewController).setLocation(loc: self.selectedLocation!)
    }
    }
    
    func addNewLocation(newLocation: location){
        print("new location")
        self.weatherInLocations.addNewLocation(newLocation: newLocation)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherInLocations.cdelegate=self
        let cellNib=UINib(nibName: "ObservedLocationCell", bundle: .main)
        self.locationsTable.register(cellNib, forCellReuseIdentifier: self.cellID)
        self.locationsTable.delegate=self
        self.locationsTable.dataSource=self
    }
    
    func modelUpdate() {
        self.tableView.reloadData()
    }
    

    
}
