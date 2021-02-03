//
//  AddCityCell.swift
//  WeatherApp_iOS
//
//  Created by User on 03.02.2021.
//

import UIKit

struct AddCityCellData{
    let name,state,country: String
}
class AddCityCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    
    var data: AddCityCellData?{
        didSet{
            var temp: String = self.data?.name ?? ""
            if(self.data?.state != ""){
                temp += ", " + (self.data?.state ?? "")
            }
            if(self.data?.country != ""){
                temp += ", " + (self.data?.country ?? "")
            }
            self.label.text=temp
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
