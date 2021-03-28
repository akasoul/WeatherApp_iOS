//
//  Cities.swift
//  WeatherApp_iOS
//
//  Created by User on 02.02.2021.
//

import Foundation

protocol AddLocationModelListener: class{
    func modelUpdate()
}

class AddLocationModel{
    weak var listener: AddLocationModelListener?
    
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
            DispatchQueue.main.async{
                self.listener?.modelUpdate()
            }
        }
    }
    private var filteredData: [location] = []{
        didSet{
            DispatchQueue.main.async{
                self.listener?.modelUpdate()
            }
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
                return
            }
        }
        DispatchQueue.global(qos: .userInteractive).async{
            var str: String?
            do{
                str=try String(contentsOf: url)
            }
            catch{
                print(error)
            }
            
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
            
            self.structIsReady=true
        }
    }
    
    func getCount()->Int{
        return self.filteredData.count
    }
    
    func setFilter(str:String){
        self.filterString=str
    }
    
    func performFilter(){
        DispatchQueue.global().sync{
            if(self.structIsReady){
                self.newFilter=false
                if(self.filterString==""){
                    self.filteredData=self.data ?? []
                }
                else{
                    var tmp=[location]()
                    for i in 0..<(self.data?.count ?? 0){
                        if(self.data![i].name.lowercased().contains(self.filterString.lowercased())){
                            tmp.append(self.data![i])
                        }
                    }
                    self.filteredData=tmp
                }
            }
        }
    }
    
    func getAt(index: Int)->location?{
        if(index<self.filteredData.count){
            return self.filteredData[index]
        }
        return nil
    }
    
}


