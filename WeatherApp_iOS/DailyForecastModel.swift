//
//  DailyForecastModel.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 07.02.2021.
//

import Foundation

protocol DailyForecastDelegate: class{
    func modelUpdate()
}


class DailyForecastModel{
    var cdelegate: DailyForecastDelegate?
    private var selectedLocation: location?{
        didSet{
            let url=URL(string:"https://api.openweathermap.org/data/2.5/onecall?lat=\(self.selectedLocation!.coord.lat)&lon=\(self.selectedLocation!.coord.lon)&exclude=hourly,current,minutely,alerts&appid=0601def1087b7d7381320d12039fea10")
            if(url == nil){
                return
            }
            var answer: String=""
            var jsonData: DailyForecastJson?
            let task=URLSession.shared.dataTask(with: url!){data, response, error in
                guard let data = data else { return }
                answer=(String(data: data, encoding: .utf8)!)
                do{
                    jsonData = try JSONDecoder().decode(DailyForecastJson.self, from: answer.data(using: .utf8)!)
                }
                catch{
                    print("err")
                }
            }
            task.resume()
            while(!task.progress.isFinished){
                sleep(1)
            }
            print(jsonData)
        }
    }
    
    func setLocation(loc: location){
        self.selectedLocation=loc
    }
}