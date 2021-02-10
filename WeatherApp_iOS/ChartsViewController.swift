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
        if temperatureData.count>0{
            let max=temperatureData.max()!
            let path=UIBezierPath()
            let viewWidth=self.temperatureChartView.frame.width
            let viewHeight=self.temperatureChartView.frame.height
            let step: CGFloat=viewWidth/CGFloat(temperatureData.count)
            path.move(to: CGPoint(x: 0, y: viewHeight))
            for i in 0..<temperatureData.count{
                let point = CGPoint(x: CGFloat(i)*step, y: viewHeight*CGFloat(temperatureData[i])/CGFloat(max) )
                print(point)
                path.addLine(to: point)
            }
            let caLayer=CAShapeLayer()
            caLayer.fillColor = .none
            caLayer.strokeColor = UIColor.blue.cgColor
            caLayer.path=path.cgPath
            self.temperatureChartView.layer.addSublayer(caLayer)
        }
    }
    
}
