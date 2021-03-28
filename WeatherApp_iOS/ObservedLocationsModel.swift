//
//  WeatherInLocations.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 04.02.2021.
//

import Foundation
import UIKit

protocol ObservedLocationModelListener: class{
    func modelUpdate()
}




class ObservedLocationsModel{
    weak var listener: ObservedLocationModelListener?
    
    private var observedLocations:[location]=[]{
        didSet{
            let encoder=JSONEncoder()
            if let encoded = try? encoder.encode(self.observedLocations){
                UserDefaults.standard.setValue(encoded, forKey: "observedLocations")
            }
            self.requestWeather()
        }
    }
    
    private var currentWeather: [CurrentWeatherJSON]=[]{
        didSet{
            if(self.currentWeather==[]){
                return
            }
            var foundNil=false
            for i in 0..<self.currentWeather.count{
                if(self.currentWeather[i] == CurrentWeatherJSON.nilValue){
                    foundNil=true
                }
            }
            if !foundNil{
                self.listener?.modelUpdate()
            }
        }
    }
    
    init() {
        let decoder=JSONDecoder()
        let value=UserDefaults.standard.value(forKey: "observedLocations")
        if(value != nil){
            if let decoded = try? decoder.decode([location].self, from: value! as! Data){
                self.observedLocations=decoded
                self.requestWeather()
            }
        }
        
        
    }
    
    func requestWeather(){
        DispatchQueue.global().async{
        for i in 0..<self.observedLocations.count{
            if(i<self.currentWeather.count){
                if(self.observedLocations[i].name==self.currentWeather[i].name){
                    continue
                }
            }
            var answer=""
            var responseJson: CurrentWeatherJSON?
            let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?id=\(self.observedLocations[i].id)&appid=0601def1087b7d7381320d12039fea10")
            if(url == nil){
                continue
            }
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                guard let data = data else { return }
                answer=(String(data: data, encoding: .utf8)!)
                do{
                    responseJson = try JSONDecoder().decode(CurrentWeatherJSON.self, from: answer.data(using: .utf8)!)
                    self.currentWeather.append(responseJson ?? CurrentWeatherJSON.nilValue)
                }
                catch{
                    print(error)
                }
            }
            
            task.resume()
            while !task.progress.isFinished{
                sleep(1)
            }
        }
        }
    }
    
    func addNewLocation(newLocation: location){
        DispatchQueue.global().sync{
            for i in 0..<self.observedLocations.count{
                if(self.observedLocations[i] == newLocation){
                    return
                }
            }
            self.observedLocations.append(newLocation)
        }
    }
    
    func getAt(index: Int)->CurrentWeatherJSON{
        return self.currentWeather[index]
    }
    
    func deleteAt(index: Int){
        if(index<self.observedLocations.count && index<self.currentWeather.count){
            self.observedLocations.remove(at: index)
            self.currentWeather.remove(at: index)
        }
    }
    func getCount()->Int{
        return self.currentWeather.count
    }
}
