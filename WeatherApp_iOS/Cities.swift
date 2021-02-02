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
            self.data?.sort(by: { $0.name! < $1.name! })
            cdelegate?.structIsReady()
        }
    }
    private var filteredData: [cityStruct] = []{
        didSet{
            cdelegate?.structIsReady()
        }
    }
    var filter: String = ""
    
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
            //let strArray=str!.split(separator: ",")
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
        if(self.filteredData.count>0){
            return self.filteredData.count
        }
        return self.data?.count
    }
    
    func setFilter(str:String){
        self.filter=str
        self.filteredData=[]
        DispatchQueue.global(qos: .background).async {
            for i in 0..<self.data!.count{
                if(self.data![i].name!.lowercased().contains(self.filter.lowercased())){
                    self.filteredData.append(self.data![i])
                }
            }
        }
    }
    func getAt(index: Int)->cityStruct?{
        if(self.filteredData.count>0){
            return self.filteredData[index]
        }
        if(self.data != nil){
            if(index<self.data!.count){
                return self.data![index]
            }
        }
        return nil
    }
}
