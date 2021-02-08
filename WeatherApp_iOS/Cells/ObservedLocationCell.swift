//
//  ObservedLocationCell.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 05.02.2021.
//

import UIKit

struct ObservedLocationStruct{
    let name: String
    let temperature: Double
    let wind: String
    let weather: UIImage
}
class ObservedLocationCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    
    var data: ObservedLocationStruct?{
        didSet{
            self.cityLabel.text=self.data?.name
            self.temperatureLabel.text=String(format: "%.1f ºC",self.data!.temperature - 273)
            self.weatherIcon.image=self.data?.weather
            self.windLabel.text=self.data?.wind
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
