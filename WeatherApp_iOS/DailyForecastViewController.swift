//
//  DailyForecastViewController.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 07.02.2021.
//

import UIKit

class DailyForecastViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DailyForecastDelegate {
    private let cellID="dfCell"
    private var selectedLocation: location?{
        didSet{
            self.model.setLocation(loc: self.selectedLocation!)
        }
    }
    func setLocation(loc: location){
        self.selectedLocation=loc
    }
    @IBOutlet weak var table: UITableView?
    
    private let model = DailyForecastModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model.cdelegate=self
        
        let cell = UINib(nibName: "ObservedLocationCell", bundle: .main)
        self.table?.register(cell, forCellReuseIdentifier: self.cellID)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...

        return UITableViewCell()
    }
    
    func modelUpdate() {
         
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
