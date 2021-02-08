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
    private var structIsReady=false
    private var data: [location]?{
        didSet{
            self.data?.sort(by: { $0.name < $1.name })
            cdelegate?.structIsReady()
        }
    }
    private var filteredData: [location] = []{
        didSet{
            cdelegate?.structIsReady()
        }
    }
    var filter: String = ""
    
    init(){
        
        
        
        let path = Bundle.main.bundlePath+"/city.list.json"
        let url = URL(fileURLWithPath: path)//URL(string: path)
        let folderPath=Bundle.main.bundlePath+"/citiesFolder"
        let path2=Bundle.main.bundlePath+"/citiesFolder/hc.swift"
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
        if(str.count<3){
            return
        }
        self.filter=str
        while(!self.structIsReady){
            sleep(1)
        }
        self.workItem?.cancel()
        self.workItem=DispatchWorkItem(block: {
            print("workItemPerform")
            //self.filteredData=[]
            var tmp=[location]()
            DispatchQueue.global(qos: .background).async {
                for i in 0..<self.data!.count{
                    if(self.data![i].name.lowercased().contains(self.filter.lowercased())){
                        tmp.append(self.data![i])
                    }
                }
                self.filteredData=tmp
            }
        })
        self.workItem?.perform()
        
    }
    func getAt(index: Int)->location?{
        return self.filteredData[index]
    }
}


