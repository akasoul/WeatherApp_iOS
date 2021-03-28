//
//  ChartsViewController.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 09.02.2021.
//

import UIKit

class ChartsViewController: UIViewController, ChartsModelListener {
    func modelUpdate() {
        self.drawTemperatureChart()
        self.drawPressureChart()
        self.drawHumidityChart()
        self.drawUviChart()
    }
    
    @IBOutlet weak var temperatureChartView: UIView!
    @IBOutlet weak var pressureChartView: UIView!
    @IBOutlet weak var humidityChartView: UIView!
    @IBOutlet weak var uviChartView: UIView!
    
    
    
    private var selectedLocation: location?{
        didSet{
            self.model.setLocation(loc: self.selectedLocation!)
        }
    }
    let model = ChartsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawTemperatureChart()
        self.drawPressureChart()
        self.drawHumidityChart()
        self.drawUviChart()
        self.model.listener=self
        // Do any additional setup after loading the view.
    }
    
    func setLocation(loc: location){
        self.selectedLocation=loc
    }
    
    func drawTemperatureChart(){
        let temperatureData=self.model.getTemperatureData()
        let temperatureMaxData=self.model.getTemperatureMaxData()
        let temperatureMinData=self.model.getTemperatureMinData()
        if(temperatureData.count != temperatureMaxData.count || temperatureData.count != temperatureMinData.count){
            return
        }
        
        let viewWidth=self.temperatureChartView.frame.width
        let viewHeight=self.temperatureChartView.frame.height
        
        let dates=self.model.getDates()
        
        let clrMax=UIColor.red.cgColor
        let clrMin=UIColor.blue.cgColor
        let clrMid=UIColor.gray.cgColor
        let clrGrid=UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5).cgColor
        
        
        let max=CGFloat(temperatureMaxData.max() ?? 0)
        let min=CGFloat(temperatureMinData.min() ?? 0) == max ? 0 : CGFloat(temperatureMinData.min() ?? 0)
        
        if(max==min){
            return
        }
        
        
        let yGridCount=Int(CGFloat(temperatureData.count)*(viewHeight/viewWidth))
        let yGridTemperatureStep: CGFloat = (abs(max)-abs(min))/CGFloat(yGridCount-1)
        let xStep: CGFloat=viewWidth/CGFloat(temperatureData.count-1)
        let yStep: CGFloat=viewHeight/CGFloat(yGridCount-1)
        
        
        let formatter=DateFormatter()
        formatter.locale=Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMd")
        
        
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
            
            //marks
            let textLayer=CATextLayer()
            textLayer.string=formatter.string(from: dates[i])
            textLayer.fontSize=12
            textLayer.frame=CGRect(x: xPos, y: yPosEnd+0.5*textLayer.fontSize, width: 50, height: 50)
            textLayer.alignmentMode = .left
            textLayer.foregroundColor = UIColor.black.cgColor
            let transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
            textLayer.setAffineTransform(transform)
            self.temperatureChartView.layer.addSublayer(textLayer)
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
            
            //marks
            let textLayer=CATextLayer()
            textLayer.string=String(format: "%.1f ºC", max+CGFloat(i)*yGridTemperatureStep)
            textLayer.fontSize=12
            textLayer.frame=CGRect(x: -52, y: yPos-0.5*textLayer.fontSize, width: 48, height: 100)
            textLayer.alignmentMode = .right
            textLayer.foregroundColor = UIColor.black.cgColor
            let transform = CGAffineTransform(rotationAngle: 0)
            textLayer.setAffineTransform(transform)
            self.temperatureChartView.layer.addSublayer(textLayer)
        }
        
        for (data,clr) in [(temperatureData,clrMid),(temperatureMaxData,clrMax),(temperatureMinData,clrMin)]{
            let path=UIBezierPath()
            for i in 0..<data.count{
                let xPos = CGFloat(i)*xStep
                let yPos = viewHeight-viewHeight*(CGFloat(data[i])-min)/(max-min)
                let point = CGPoint(x: xPos, y: yPos )
                
                if(i==0){
                    path.move(to: CGPoint(x: xPos, y: yPos))
                }
                else{
                    path.addLine(to: point)
                }
                
                let pointsLayer=CAShapeLayer()
                pointsLayer.fillColor=clr
                let rectSize:CGFloat=4
                let rect=CGRect(x: point.x-rectSize/2, y: point.y-rectSize/2, width: rectSize, height: rectSize)
                pointsLayer.path=UIBezierPath(roundedRect: rect, cornerRadius: 1).cgPath
                self.temperatureChartView.layer.addSublayer(pointsLayer)
                
            }
            let caLayer=CAShapeLayer()
            caLayer.fillColor = .none
            caLayer.strokeColor = clr
            caLayer.lineWidth=2
            caLayer.path=path.cgPath
            self.temperatureChartView.layer.addSublayer(caLayer)
            
        }
        
    }
    
    
    func drawPressureChart(){
        
        let pressureData=self.model.getPressureData()
        
        let viewWidth=self.temperatureChartView.frame.width
        let viewHeight=self.temperatureChartView.frame.height
        
        let xOffset=viewWidth*0.1
        let columnWidth=viewWidth*0.1
        
        let dates=self.model.getDates()
        
        let columnFillColor=UIColor(red: 0, green: 0, blue: 1, alpha: 0.5).cgColor
        let columnStrokeColor=UIColor(red: 0.2, green: 0.2, blue: 0.9, alpha: 0.5).cgColor
        let clrGrid=UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5).cgColor
        
        var max=CGFloat(pressureData.max() ?? 0)
        var min=CGFloat(pressureData.min() ?? 0)
        
        if(max==min){
            return
        }
        
        max+=(max-min)*0.1
        min-=(max-min)*0.1
        
        let yGridCount=Int(CGFloat(pressureData.count)*(viewHeight/viewWidth))
        let yGridPressureStep: CGFloat = (abs(max)-abs(min))/CGFloat(yGridCount-1)
        let xStep: CGFloat=(viewWidth-2*xOffset)/CGFloat(pressureData.count-1)
        let yStep: CGFloat=viewHeight/CGFloat(yGridCount-1)
        
        let formatter=DateFormatter()
        formatter.locale=Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMd")
        
        //x grid
        for i in 0..<pressureData.count{
            let path=UIBezierPath()
            let gridLayer=CAShapeLayer()
            gridLayer.strokeColor=clrGrid
            let xPos:CGFloat = CGFloat(i)*xStep+xOffset
            let yPosStart:CGFloat = 0
            let yPosEnd:CGFloat = viewHeight
            path.move(to: CGPoint(x: xPos, y: yPosStart))
            path.addLine(to: CGPoint(x: xPos, y: yPosEnd))
            gridLayer.path=path.cgPath
            self.pressureChartView.layer.addSublayer(gridLayer)
            
            //marks
            let textLayer=CATextLayer()
            textLayer.string=formatter.string(from: dates[i])
            textLayer.fontSize=12
            textLayer.frame=CGRect(x: xPos, y: yPosEnd+0.5*textLayer.fontSize, width: 50, height: 50)
            textLayer.alignmentMode = .left
            textLayer.foregroundColor = UIColor.black.cgColor
            let transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
            textLayer.setAffineTransform(transform)
            self.pressureChartView.layer.addSublayer(textLayer)
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
            self.pressureChartView.layer.addSublayer(gridLayer)
            
            //marks
            let textLayer=CATextLayer()
            textLayer.string=String(format: "%.0f", max-CGFloat(i)*yGridPressureStep)
            textLayer.fontSize=12
            textLayer.frame=CGRect(x: -52, y: yPos-0.5*textLayer.fontSize, width: 48, height: 100)
            textLayer.alignmentMode = .right
            textLayer.foregroundColor = UIColor.black.cgColor
            let transform = CGAffineTransform(rotationAngle: 0)
            textLayer.setAffineTransform(transform)
            self.pressureChartView.layer.addSublayer(textLayer)
        }
        
        for i in 0..<pressureData.count{
            let xPos = CGFloat(i)*xStep+xOffset
            let yPos = viewHeight-viewHeight*(CGFloat(pressureData[i])-min)/(max-min)
            let rect=CGRect(x: xPos-columnWidth*0.5, y: yPos, width: columnWidth, height: viewHeight-yPos)
            let path=UIBezierPath(rect: rect)
            
            let rectslayer=CAShapeLayer()
            rectslayer.fillColor=columnFillColor
            rectslayer.strokeColor=columnStrokeColor
            rectslayer.lineWidth=2
            rectslayer.path=path.cgPath
            self.pressureChartView.layer.addSublayer(rectslayer)
        }
    }
    
    
    func drawHumidityChart(){
        
        let humidityData=self.model.getHumidityData()
        let viewWidth=self.temperatureChartView.frame.width
        let viewHeight=self.temperatureChartView.frame.height
        
        let dates=self.model.getDates()
        
        let clrGrid=UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5).cgColor
        let clrLine=UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1).cgColor
        
        let max:CGFloat=100
        let min:CGFloat=0
        
        let yGridCount=Int(CGFloat(humidityData.count)*(viewHeight/viewWidth))
        let yGridHumidityStep: CGFloat = (abs(max)-abs(min))/CGFloat(yGridCount-1)
        let xStep: CGFloat=viewWidth/CGFloat(humidityData.count-1)
        let yStep: CGFloat=viewHeight/CGFloat(yGridCount-1)
        
        let formatter=DateFormatter()
        formatter.locale=Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMd")
        
        //background gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame=self.humidityChartView.bounds
        gradientLayer.colors=[UIColor(red: 0, green: 0, blue: 1, alpha: 0.2).cgColor,UIColor(red: 1.0, green: 1.0, blue: 0, alpha: 0.2).cgColor]
        self.humidityChartView.layer.insertSublayer(gradientLayer, at: 0)
        
        //x grid
        for i in 0..<humidityData.count{
            let path=UIBezierPath()
            let gridLayer=CAShapeLayer()
            gridLayer.strokeColor=clrGrid
            let xPos:CGFloat = CGFloat(i)*xStep
            let yPosStart:CGFloat = 0
            let yPosEnd:CGFloat = viewHeight
            path.move(to: CGPoint(x: xPos, y: yPosStart))
            path.addLine(to: CGPoint(x: xPos, y: yPosEnd))
            gridLayer.path=path.cgPath
            self.humidityChartView.layer.addSublayer(gridLayer)
            
            //marks
            let textLayer=CATextLayer()
            textLayer.string=formatter.string(from: dates[i])
            textLayer.fontSize=12
            textLayer.frame=CGRect(x: xPos, y: yPosEnd+0.5*textLayer.fontSize, width: 50, height: 50)
            textLayer.alignmentMode = .left
            textLayer.foregroundColor = UIColor.black.cgColor
            let transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
            textLayer.setAffineTransform(transform)
            self.humidityChartView.layer.addSublayer(textLayer)
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
            self.humidityChartView.layer.addSublayer(gridLayer)
            
            //marks
            let textLayer=CATextLayer()
            textLayer.string=String(format: "%.1f %%", max-CGFloat(i)*yGridHumidityStep)
            textLayer.fontSize=12
            textLayer.frame=CGRect(x: -52, y: yPos-0.5*textLayer.fontSize, width: 48, height: 100)
            textLayer.alignmentMode = .right
            textLayer.foregroundColor = UIColor.black.cgColor
            let transform = CGAffineTransform(rotationAngle: 0)
            textLayer.setAffineTransform(transform)
            self.humidityChartView.layer.addSublayer(textLayer)
        }
        
        let path=UIBezierPath()
        for i in 0..<humidityData.count{
            let xPos = CGFloat(i)*xStep
            let yPos = viewHeight-viewHeight*(CGFloat(humidityData[i])-min)/(max-min)
            let point = CGPoint(x: xPos, y: yPos )
            
            if(i==0){
                path.move(to: CGPoint(x: xPos, y: yPos))
            }
            else{
                path.addLine(to: point)
            }
            
        }
        let caLayer=CAShapeLayer()
        caLayer.fillColor = .none
        caLayer.strokeColor = clrLine
        caLayer.lineWidth=2
        caLayer.path=path.cgPath
        self.humidityChartView.layer.addSublayer(caLayer)
        
    }
    
    func drawUviChart(){
        let uviData=self.model.getUviData()
        let viewWidth=self.temperatureChartView.frame.width
        let viewHeight=self.temperatureChartView.frame.height
        
        let dates=self.model.getDates()
        
        let clrGrid=UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5).cgColor
        let clrLine=UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1).cgColor
        
        var max:CGFloat=CGFloat(uviData.max() ?? 0)
        var min:CGFloat=CGFloat(uviData.min() ?? 0)
        
        if(min==max){
            return
        }
        
        max+=(max-min)*0.1
        min-=(max-min)*0.1
        
        let yGridCount=Int(CGFloat(uviData.count)*(viewHeight/viewWidth))
        let yGridUviStep: CGFloat = (abs(max)-abs(min))/CGFloat(yGridCount-1)
        let xStep: CGFloat=viewWidth/CGFloat(uviData.count-1)
        let yStep: CGFloat=viewHeight/CGFloat(yGridCount-1)
        
        let formatter=DateFormatter()
        formatter.locale=Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMd")
        
        //x grid
        for i in 0..<uviData.count{
            let path=UIBezierPath()
            let gridLayer=CAShapeLayer()
            gridLayer.strokeColor=clrGrid
            let xPos:CGFloat = CGFloat(i)*xStep
            let yPosStart:CGFloat = 0
            let yPosEnd:CGFloat = viewHeight
            path.move(to: CGPoint(x: xPos, y: yPosStart))
            path.addLine(to: CGPoint(x: xPos, y: yPosEnd))
            gridLayer.path=path.cgPath
            self.uviChartView.layer.addSublayer(gridLayer)
            
            //marks
            let textLayer=CATextLayer()
            textLayer.string=formatter.string(from: dates[i])
            textLayer.fontSize=12
            textLayer.frame=CGRect(x: xPos, y: yPosEnd+0.5*textLayer.fontSize, width: 50, height: 50)
            textLayer.alignmentMode = .left
            textLayer.foregroundColor = UIColor.black.cgColor
            let transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
            textLayer.setAffineTransform(transform)
            self.uviChartView.layer.addSublayer(textLayer)
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
            self.uviChartView.layer.addSublayer(gridLayer)
            
            //marks
            let textLayer=CATextLayer()
            textLayer.string=String(format: "%.1f", max-CGFloat(i)*yGridUviStep)
            textLayer.fontSize=12
            textLayer.frame=CGRect(x: -52, y: yPos-0.5*textLayer.fontSize, width: 48, height: 100)
            textLayer.alignmentMode = .right
            textLayer.foregroundColor = UIColor.black.cgColor
            let transform = CGAffineTransform(rotationAngle: 0)
            textLayer.setAffineTransform(transform)
            self.uviChartView.layer.addSublayer(textLayer)
        }
        
        let path=UIBezierPath()
        for i in 0..<uviData.count{
            let xPos = CGFloat(i)*xStep
            let yPos = viewHeight-viewHeight*(CGFloat(uviData[i])-min)/(max-min)
            let point = CGPoint(x: xPos, y: yPos )
            
            if(i==0){
                path.move(to: CGPoint(x: xPos, y: yPos))
            }
            else{
                path.addLine(to: point)
            }
            path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
            path.addLine(to: CGPoint(x: 0, y: viewHeight))

            
            
        }
        let caLayer=CAShapeLayer()
        caLayer.fillColor = clrLine
        caLayer.strokeColor = clrLine
        caLayer.lineWidth=2
        caLayer.path=path.cgPath
        
        
        //fill path
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame=self.uviChartView.bounds
        gradientLayer.colors=[UIColor(red: 0.7, green: 0.35, blue: 0.7, alpha: 0.8).cgColor, UIColor(red: 0.7, green: 0.35, blue: 0.7, alpha: 0.1).cgColor]
        gradientLayer.mask=caLayer
        self.uviChartView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
}
