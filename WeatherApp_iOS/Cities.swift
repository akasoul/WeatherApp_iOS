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
    let state: String?
    let coord: coordinates?
}

class Cities{
    var cdelegate: CitiesDelegate?
    var workItem: DispatchWorkItem?
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
        
        
        
        let path = Bundle.main.bundlePath+"/city.list.json"
        let url = URL(fileURLWithPath: path)//URL(string: path)
        let folderPath=Bundle.main.bundlePath+"/citiesFolder"
        let path2=Bundle.main.bundlePath+"/citiesFolder/hc.txt"
        if(!FileManager.default.fileExists(atPath: folderPath)){
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: [:])
            }
            catch{
                
            }
        }
        DispatchQueue.global(qos: .background).async{
            
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
            print(path2)
            FileManager.default.createFile(atPath: path2, contents: nil, attributes: [:])
            let fh=FileHandle(forUpdatingAtPath: path2)
            fh?.write("[".data(using: .utf8)!)

            
            for i in 0..<(self.data?.count ?? 0){
                if(self.data![i].name=="-"){
                    continue
                }
                var str=""
                str += "cityStruct(id: \(self.data![i].id!), name: \""+self.data![i].name!+"\", country: \""+self.data![i].country!+"\", state: \""+self.data![i].state!+"\", coord: cityStruct.coordinates(lon: \(self.data![i].coord!.lon!), lat: \(self.data![i].coord!.lat!))),"
                
                fh?.write(str.data(using: .utf8)!)
            }
            
            fh?.write("]".data(using: .utf8)!)

            
        }
        
    }
    
    func getCount()->Int?{
        if(self.filteredData.count>0){
            return self.filteredData.count
        }
        return self.data?.count
    }
    
    func setFilter(str:String){
        if(str.count<3){
            return
        }
        self.filter=str
        self.workItem?.cancel()
        self.workItem=DispatchWorkItem(block: {
            print("workItemPerform")
            self.filteredData=[]
            DispatchQueue.global(qos: .background).async {
                for i in 0..<self.data!.count{
                    if(self.data![i].name!.lowercased().contains(self.filter.lowercased())){
                        self.filteredData.append(self.data![i])
                    }
                }
            }
        })
        self.workItem?.perform()
        
    }
    func getAt(index: Int)->cityStruct?{
        if(self.filteredData.count>0 && index<self.filteredData.count){
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


