//
//  DailyForecastCell.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 07.02.2021.
//

import UIKit

class DailyForecastCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    
    var data: Daily?{
        didSet{
            if(self.dateLabel != nil && self.tempLabel != nil && self.weatherImage != nil){
                let formatter=DateFormatter()
                formatter.locale=Locale(identifier: "en_US")
                formatter.setLocalizedDateFormatFromTemplate("MMMd")
                
                self.dateLabel.text=formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.data?.dt ?? 0)))
                self.tempLabel.text=String(format: "%.1f",(self.data?.temp?.min ?? 0)-273) + "..." + String(format: "%.1f",(self.data?.temp?.max ?? 0)-273) + " ºC"
                self.weatherImage.image=UIImage(named: self.data?.weather?[0].icon ?? "")
            }
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

