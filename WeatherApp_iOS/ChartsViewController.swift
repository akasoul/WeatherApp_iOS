//
//  ChartsViewController.swift
//  WeatherApp_iOS
//
//  Created by Anton Voloshuk on 09.02.2021.
//

import UIKit

class ChartsViewController: UIViewController {
    @IBOutlet weak var temperatureChartView: UIView!
    @IBOutlet weak var pressureChartView: UIView!
    @IBOutlet weak var humidityChartView: UIView!
    @IBOutlet weak var uviChartView: UIView!

    let model = ChartsModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let temperatureChart=UIBezierPath()
        temperatureChart.move(to: CGPoint(x: 0, y: 0))
        temperatureChart.addLine(to: CGPoint(x: 10, y: 30))
        temperatureChart.addLine(to: CGPoint(x: 20, y: 100))
        temperatureChart.addLine(to: CGPoint(x: 30, y: 50))
        let caLayer=CAShapeLayer()
        caLayer.fillColor = .none
        caLayer.strokeColor = UIColor.blue.cgColor
        caLayer.path=temperatureChart.cgPath
        self.temperatureChartView.layer.addSublayer(caLayer)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
