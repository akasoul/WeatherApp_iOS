//
//  Cities.swift
//  WeatherApp_iOS
//
//  Created by User on 02.02.2021.
//

import Foundation


struct cityStruct: Decodable{
    struct coordinates: Decodable{
        let lon: Double?
        let lat: Double?
    }
    let id: Int?
    let name: String?
    let country: String?
    let coord: coordinates?
}

class Cities{
    var cdelegate: CitiesDelegate?
    private var data: [cityStruct]?{
        didSet{
            cdelegate?.structIsReady()
        }
    }
    
    
    init(){
        DispatchQueue.global(qos: .background).async{
            let path = Bundle.main.bundlePath+"/city.list.json"
            let url = URL(fileURLWithPath: path)//URL(string: path)
            var str: String?
            do{
                str=try String(contentsOf: url)
            }
            catch{
                print(error)
            }
            var tmp: [cityStruct]?
            do{
                tmp = try JSONDecoder().decode([cityStruct].self, from: str!.data(using: .utf8)!)
                if(tmp==nil){
                    return
                }
                
                self.data=tmp
            }
            catch{
                print(error)
            }
        }
    }
    
    func getCount()->Int?{
        return self.data?.count
    }
    
    func getAt(index: Int)->cityStruct?{
        
        if(self.data != nil){
            if(index<self.data!.count){
                return self.data![index]
            }
        }
        return nil
    }
}
