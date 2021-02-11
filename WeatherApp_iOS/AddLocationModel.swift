//
//  Cities.swift
//  WeatherApp_iOS
//
//  Created by User on 02.02.2021.
//

import Foundation



class AddLocationModel{
    var cdelegate: CitiesDelegate?
    
    private var workItem: DispatchWorkItem?
    private var structIsReady=false{
        didSet{
            if(self.newFilter && self.structIsReady){
                self.performFilter()
            }
        }
    }
    private var data: [location]?{
        didSet{
            self.data?.sort(by: { $0.name < $1.name })
            cdelegate?.modelUpdate()
        }
    }
    private var filteredData: [location] = []{
        didSet{
            cdelegate?.modelUpdate()
        }
    }
    private var filterString: String = ""{
        didSet{
            if(self.structIsReady){
                self.performFilter()
            }
            else{
                self.newFilter=true
            }
        }
    }
    private var newFilter = false
    
    init(){
        let path = Bundle.main.bundlePath+"/city.list.json"
        let url = URL(fileURLWithPath: path)//URL(string: path)
        let folderPath=Bundle.main.bundlePath+"/citiesFolder"
        if(!FileManager.default.fileExists(atPath: folderPath)){
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: [:])
            }
            catch{
                
            }
        }
        DispatchQueue.global(qos: .userInteractive).async{
            let t1=Date()
            var str: String?
            do{
                str=try String(contentsOf: url)
            }
            catch{
                print(error)
            }
            let t2=Date()
            print(t2.timeIntervalSince(t1))
            
            var tmp: [location]?
            do{
                tmp = try JSONDecoder().decode([location].self, from: str!.data(using: .utf8)!)
                if(tmp==nil){
                    return
                }
                self.data=tmp
            }
            catch{
                print(error)
            }
            let t3=Date()
            print(t3.timeIntervalSince(t2))
            
            self.structIsReady=true
        }
    }
    
    func getCount()->Int?{
        return self.filteredData.count
    }
    
    func setFilter(str:String){
        self.filterString=str
    }
    
    func performFilter(){
        DispatchQueue.global().sync{
            if(self.structIsReady){
                if(self.filterString==""){
                    self.filteredData=self.data ?? []
                    self.newFilter=false
                    return
                }
                else{
                    var tmp=[location]()
                    for i in 0..<(self.data?.count ?? 0){
                        if(self.data![i].name.lowercased().contains(self.filterString.lowercased())){
                            tmp.append(self.data![i])
                        }
                    }
                    self.filteredData=tmp
                    self.newFilter=false
                }
            }
        }
    }
    
    func getAt(index: Int)->location?{
        return self.filteredData[index]
    }
    
}


