//
//  DailyForecastViewController.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 07.02.2021.
//

import UIKit

class DailyForecastViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DailyForecastDelegate {
    @IBOutlet weak var table: UITableView!
    private let cellID="dfCell"
    private var selectedLocation: location?{
        didSet{
            self.model.setLocation(loc: self.selectedLocation!)
        }
    }
    func setLocation(loc: location){
        self.selectedLocation=loc
    }
    
    private let model = DailyForecastModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model.cdelegate=self
        
        let cell = UINib(nibName: "DailyForecastCell", bundle: .main)
        self.table.register(cell, forCellReuseIdentifier: self.cellID)
        self.table.dataSource=self
        self.table.delegate=self
        self.table.separatorStyle = .none
    }


     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.getCount()
    }


    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = table?.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! DailyForecastCell

        let data = self.model.getAt(index: indexPath.row)
        if(data != nil){
            cell.data=data
            return cell
        }

        return UITableViewCell()
    }
    
    func modelUpdate() {
        self.table?.reloadData()
    }
    
}
