//
//  WeatherInLocations.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 04.02.2021.
//

import Foundation
import UIKit

protocol ObservdedLocationsDelegate: class{
    func modelUpdate()
}




class ObservedLocationsModel{
    var cdelegate: ObservdedLocationsDelegate?
    
    private var observedLocations:[location]=[]{
        didSet{
            let encoder=JSONEncoder()
            if let encoded = try? encoder.encode(self.observedLocations){
                UserDefaults.standard.setValue(encoded, forKey: "observedLocations")
            }
            self.cdelegate?.modelUpdate()
        }
    }
    
    private var currentWeather: [WeatherJson]=[]{
        didSet{
            var foundNil=false
            for i in 0..<self.currentWeather.count{
                if(self.currentWeather[i] == WeatherJson.nilValue){
                    foundNil=true
                }
            }
            if !foundNil{
            self.cdelegate?.modelUpdate()
            }
        }
    }
    
    init() {
        let decoder=JSONDecoder()
        let value=UserDefaults.standard.value(forKey: "observedLocations")
        if(value != nil){
        if let decoded = try? decoder.decode([location].self, from: value! as! Data){
            self.observedLocations=decoded
        }
        }
        //self.currentWeather=[WeatherJson].init(repeating: WeatherJson.nilValue, count: self.observedLocations.count)
        //DispatchQueue.global().async{
            for i in 0..<self.observedLocations.count{
                var answer=""
                var responseJson: WeatherJson?
                let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?id=\(self.observedLocations[i].id)&appid=0601def1087b7d7381320d12039fea10")
                if(url == nil){
                    continue
                }
                let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                    guard let data = data else { return }
                    answer=(String(data: data, encoding: .utf8)!)
                    do{
                        responseJson = try JSONDecoder().decode(WeatherJson.self, from: answer.data(using: .utf8)!)
                    }
                    catch{
                        print(error)
                    }
                }
                
                task.resume()
                while !task.progress.isFinished{
                    sleep(1)
                }
                self.currentWeather.append(responseJson ?? WeatherJson.nilValue)
            }
        //}
    }
    
    func addNewLocation(newLocation: location){
        self.observedLocations.append(newLocation)
    }
    
    func getLocationsList()->[location]{
        return self.observedLocations
    }
    
    func getLocationsCount()->Int{
        return self.observedLocations.count
    }
    
    func getAt(index: Int)->WeatherJson{
        return self.currentWeather[index]
    }
    
    func deleteAt(index: Int){
        if(index<self.currentWeather.count){
        self.currentWeather.remove(at: index)
        }
    }
    func getCount()->Int{
        return self.currentWeather.count
    }
}