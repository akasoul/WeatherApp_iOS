//
//  ChartsViewController.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 09.02.2021.
//

import UIKit

class ChartsViewController: UIViewController, ChartsModelDelegate {
    func modelUpdate() {
        self.temperatureChartInit()
    }
    
    @IBOutlet weak var temperatureChartView: UIView!
    @IBOutlet weak var pressureChartView: UIView!
    @IBOutlet weak var humidityChartView: UIView!
    @IBOutlet weak var uviChartView: UIView!
    @IBOutlet weak var labelTemperatureMax: UILabel!
    @IBOutlet weak var labelTemperatureMin: UILabel!
    @IBOutlet weak var labelDateNow: UILabel!
    @IBOutlet weak var labelDateFuture: UILabel!
    
    
    private var selectedLocation: location?{
        didSet{
            self.model.setLocation(loc: self.selectedLocation!)
        }
    }
    let model = ChartsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.temperatureChartInit()
        self.model.cdelegate=self
        // Do any additional setup after loading the view.
    }
    
    func setLocation(loc: location){
        self.selectedLocation=loc
    }
    
    func temperatureChartInit(){
        let temperatureData=self.model.getTemperatureData()
        let temperatureMaxData=self.model.getTemperatureMaxData()
        let temperatureMinData=self.model.getTemperatureMinData()
        
        let clrMax=UIColor.red.cgColor
        let clrMin=UIColor.blue.cgColor
        let clrMid=UIColor.gray.cgColor
        let clrGrid=UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5).cgColor
        
        let temperatures=[temperatureData,temperatureMaxData,temperatureMinData]
        let clrs=[clrMid,clrMax,clrMin]
        
        let max=CGFloat(temperatureMaxData.max() ?? 0)
        let min=CGFloat(temperatureMinData.min() ?? 0) == max ? 0 : CGFloat(temperatureMinData.min() ?? 0)

        

        let viewWidth=self.temperatureChartView.frame.width
        let viewHeight=self.temperatureChartView.frame.height
        let yGridCount=Int(CGFloat(temperatureData.count-1)*(viewHeight/viewWidth))
        let xStep: CGFloat=viewWidth/CGFloat(temperatureData.count-1)
        let yStep: CGFloat=viewHeight/CGFloat(yGridCount)

        self.labelTemperatureMax.text=String(format:"%.0f ºC",max)
        self.labelTemperatureMin.text=String(format:"%.0f ºC",min)

        let formatter=DateFormatter()
        formatter.locale=Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMd")
        
        self.labelDateNow.text=formatter.string(from: self.model.getDateNow())
        self.labelDateFuture.text=formatter.string(from: self.model.getDateFuture())
        
        //x grid
        for i in 0..<temperatureData.count{
            let path=UIBezierPath()
            let gridLayer=CAShapeLayer()
            gridLayer.strokeColor=clrGrid
            let xPos:CGFloat = CGFloat(i)*xStep
            let yPosStart:CGFloat = 0
            let yPosEnd:CGFloat = viewHeight
            path.move(to: CGPoint(x: xPos, y: yPosStart))
            path.addLine(to: CGPoint(x: xPos, y: yPosEnd))
            gridLayer.path=path.cgPath
            self.temperatureChartView.layer.addSublayer(gridLayer)
        }
        
        //y grid
        for i in 0..<yGridCount{
            let path=UIBezierPath()
            let gridLayer=CAShapeLayer()
            gridLayer.strokeColor=clrGrid
            let xPosStart:CGFloat = 0
            let xPosEnd:CGFloat = viewWidth
            let yPos:CGFloat = CGFloat(i)*yStep
            path.move(to: CGPoint(x: xPosStart, y: yPos))
            path.addLine(to: CGPoint(x: xPosEnd, y: yPos))
            gridLayer.path=path.cgPath
            self.temperatureChartView.layer.addSublayer(gridLayer)
        }
        
        for j in 0..<temperatures.count{
            //for (data,clr) in [(temperatureData,clrMid),(temperatureMaxData,clrMin),(temperatureMinData,clrMax)]{

                let path=UIBezierPath()
                
                for i in 0..<temperatures[j].count{
                    let xPos = CGFloat(i)*xStep
                    let yPos = viewHeight-viewHeight*(CGFloat(temperatures[j][i])-min)/(max-min)
                    let point = CGPoint(x: xPos, y: yPos )
                    
                    if(i==0){
                        path.move(to: CGPoint(x: xPos, y: yPos))
                    }
                    else{
                        path.addLine(to: point)
                    }
                    
                    let rectsLayer=CAShapeLayer()
                    rectsLayer.fillColor=clrs[j]
                    let rectSize:CGFloat=4
                    let rect=CGRect(x: point.x-rectSize/2, y: point.y-rectSize/2, width: rectSize, height: rectSize)
                    rectsLayer.path=UIBezierPath(roundedRect: rect, cornerRadius: 1).cgPath
                    self.temperatureChartView.layer.addSublayer(rectsLayer)
                    
                }
                let caLayer=CAShapeLayer()
                caLayer.fillColor = .none
                caLayer.strokeColor = clrs[j]
                caLayer.lineWidth=2
                caLayer.path=path.cgPath
                self.temperatureChartView.layer.addSublayer(caLayer)
            
            
        }
        
    }
    
}
