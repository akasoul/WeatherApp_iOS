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
    let updateTime: Double=3600 //seconds
    var cdelegate: DailyForecastDelegate?
    private var dailyWeather: [Daily]?{
        didSet{
            self.cdelegate?.modelUpdate()
        }
    }
    private var selectedLocation: location?{
        didSet{
            //let path="/Users/user/Documents/WeatherApp/request/" //Bundle.main.bundlePath+"/requests/"
            let path="/Users/antonvoloshuk/Documents/WeatherApp/request/" //Bundle.main.bundlePath+"/requests/"
            let locFilePath=path+String(self.selectedLocation!.coord.lat)+"."+String(self.selectedLocation!.coord.lon)+".req"
            if(FileManager.default.fileExists(atPath: path)){
                if(FileManager.default.fileExists(atPath: locFilePath)){
                    let str=try? String(contentsOfFile: locFilePath)
                    if(str != nil){
                        let jsonData=try? JSONDecoder().decode(DailyForecastForStorage.self,from: str!.data(using: .utf8)! )
                        if(jsonData != nil){
                            if(jsonData!.data != nil){
                                if(jsonData!.dt != nil){
                                    if(jsonData!.dt! > Date().addingTimeInterval(-self.updateTime)){
                                        if(jsonData!.data!.daily != nil){
                                            var tmp: [Daily]=[]
                                            for i in 0..<jsonData!.data!.daily!.count{
                                                tmp.append(jsonData!.data!.daily![i])
                                            }
                                            self.dailyWeather=tmp
                                            return
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else{
                try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: [:])
            }
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
                    return
                }
                if(jsonData!.daily==nil){
                    return
                }
                
                var tmp: [Daily]=[]
                for i in 0..<jsonData!.daily!.count{
                    tmp.append(jsonData!.daily![i])
                }
                self.dailyWeather=tmp
                let date=Date()
                let jsonDataForStorage=DailyForecastForStorage(data: jsonData, dt: date)
                let encoded = try? JSONEncoder().encode(jsonDataForStorage)
                if(encoded != nil){
                    let url = URL(fileURLWithPath: locFilePath)
                    do{
                        try encoded!.write(to: url)
                    }
                    catch{
                        print(error)
                    }
                }
                
            }
            task.resume()
            while(!task.progress.isFinished){
                sleep(1)
            }
            
        }
    }
    
    func setLocation(loc: location){
        self.selectedLocation=loc
    }
    
    func getCount()->Int{
        return self.dailyWeather?.count ?? 0
    }
    
    func getAt(index: Int)->Daily?{
        if(index<self.getCount()){
            return self.dailyWeather?[index]
        }
        return nil
    }
}
