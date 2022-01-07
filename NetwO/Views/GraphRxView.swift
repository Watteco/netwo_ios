//
//  GraphRxView.swift
//  NetwO
//
//  Created by Alain Grange on 23/05/2021.
//

import UIKit
import AAInfographics

class GraphRxView: UIView {
    
    let percentageLabel = UILabel()
    let snrGraph = AAChartView()
    let snrNoDataLabel = UILabel()
    let rssiGraph = AAChartView()
    let rssiNoDataLabel = UILabel()
    let sfrxGraph = AAChartView()
    let sfrxNoDataLabel = UILabel()

    required override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // background
        self.backgroundColor = ColorGrey
        
        // percentage label
        percentageLabel.frame = CGRect(x: 10.0, y: 0.0, width: self.frame.size.width - 20.0, height: 30.0)
        percentageLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        percentageLabel.font = UIFont.italicSystemFont(ofSize: 14.0)
        percentageLabel.textAlignment = .center
        self.addSubview(percentageLabel)
        
        // graphs view
        let graphsView = UIView(frame: CGRect(x: 0.0, y: 30.0, width: self.frame.size.width, height: self.frame.size.height - 30.0))
        graphsView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(graphsView)
        
        // snr graph
        snrGraph.frame = CGRect(x: 0.0, y: 0.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0 + 1.0)
        snrGraph.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        snrGraph.backgroundColor = ColorGrey
        snrGraph.scrollEnabled = false
        snrGraph.isHidden = true
        graphsView.addSubview(snrGraph)
        
        // snr no data label
        snrNoDataLabel.frame = CGRect(x: 0.0, y: 0.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0)
        snrNoDataLabel.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        snrNoDataLabel.textAlignment = .center
        snrNoDataLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
        snrNoDataLabel.textColor = ColorYellow
        snrNoDataLabel.text = NSLocalizedString("chartNoData", comment: "")
        graphsView.addSubview(snrNoDataLabel)
        
        // rssi graph
        rssiGraph.frame = CGRect(x: 0.0, y: graphsView.frame.size.height / 3.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0 + 1.0)
        rssiGraph.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        rssiGraph.backgroundColor = ColorGrey
        rssiGraph.scrollEnabled = false
        rssiGraph.isHidden = true
        graphsView.addSubview(rssiGraph)
        
        // rssi no data label
        rssiNoDataLabel.frame = CGRect(x: 0.0, y: graphsView.frame.size.height / 3.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0)
        rssiNoDataLabel.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        rssiNoDataLabel.textAlignment = .center
        rssiNoDataLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
        rssiNoDataLabel.textColor = ColorYellow
        rssiNoDataLabel.text = NSLocalizedString("chartNoData", comment: "")
        graphsView.addSubview(rssiNoDataLabel)
        
        // sfrx graph
        sfrxGraph.frame = CGRect(x: 0.0, y: (graphsView.frame.size.height / 3.0) * 2.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0 + 1.0)
        sfrxGraph.autoresizingMask = [.flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        sfrxGraph.backgroundColor = ColorGrey
        sfrxGraph.scrollEnabled = false
        sfrxGraph.isHidden = true
        graphsView.addSubview(sfrxGraph)
        
        // sfrx no data label
        sfrxNoDataLabel.frame = CGRect(x: 0.0, y: (graphsView.frame.size.height / 3.0) * 2.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0)
        sfrxNoDataLabel.autoresizingMask = [.flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        sfrxNoDataLabel.textAlignment = .center
        sfrxNoDataLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
        sfrxNoDataLabel.textColor = ColorYellow
        sfrxNoDataLabel.text = NSLocalizedString("chartNoData", comment: "")
        graphsView.addSubview(sfrxNoDataLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setPercentage(percentage: Float) {
        
        if percentage == 0.0 {
            percentageLabel.text = ""
            return
        }
        
        var value = percentage
        if value > 100.0 {
            value = 100.0
        }
        
        percentageLabel.text = "\(NSLocalizedString("received", comment: "")) \(value)\(NSLocalizedString("percentage", comment: ""))"
        
        if value >= 100.0 {
            percentageLabel.textColor = UIColor(red: 0.0/255.0, green: 215.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        } else if value >= 80.0 {
            percentageLabel.textColor = UIColor(red: 144.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        } else if value >= 40.0 {
            percentageLabel.textColor = UIColor(red: 255.0/255.0, green: 165.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        } else {
            percentageLabel.textColor = .red
        }
        
    }
    
    func updateSNR(snr: [Int?]) {
        
        if snr.count > 0 {
        
            snrGraph.isHidden = false
            snrNoDataLabel.isHidden = true
            
            var categories = [String]()
            for i in 0..<snr.count {
                categories.append("\(i)")
            }
            
            var datas = [Int?]()
            for data in snr {
                datas.append(data)
            }
            
            generateGraph(chartView: snrGraph, title: "SNR", categories: categories, datas: datas, yAxisMin: -20.0, yAxixMax: 15.0, colorTheme: "#00d700")
            
        } else {
            snrGraph.isHidden = true
            snrNoDataLabel.isHidden = false
        }
        
    }
    
    func updateRSSI(rssi: [Int?]) {
        
        if rssi.count > 0 {
        
            rssiGraph.isHidden = false
            rssiNoDataLabel.isHidden = true
            
            var categories = [String]()
            for i in 0..<rssi.count {
                categories.append("\(i)")
            }
            
            var datas = [Int?]()
            for data in rssi {
                datas.append(data)
            }
            
            generateGraph(chartView: rssiGraph, title: "RSSI", categories: categories, datas: datas, yAxisMin: -130.0, yAxixMax: -20.0, colorTheme: "#00d700")
            
        } else {
            rssiGraph.isHidden = true
            rssiNoDataLabel.isHidden = false
        }
        
    }
    
    func updateSFRX(sfrx: [Int?]) {
        
        if sfrx.count > 0 {
            
            sfrxGraph.isHidden = false
            sfrxNoDataLabel.isHidden = true
        
            var categories = [String]()
            for i in 0..<sfrx.count {
                categories.append("\(i)")
            }
            
            var datas = [Int?]()
            for data in sfrx {
                datas.append(data)
            }
            
            generateGraph(chartView: sfrxGraph, title: "SFRX", categories: categories, datas: datas, yAxisMin: 6.0, yAxixMax: 13.0, colorTheme: "#8beafe")
            
        } else {
            sfrxGraph.isHidden = true
            sfrxNoDataLabel.isHidden = false
        }
        
    }
    
    func generateGraph(chartView: AAChartView, title: String, categories: [String], datas: [Int?], yAxisMin: Double, yAxixMax: Double, colorTheme: String) {
        
        let chartModel = AAChartModel()
            .backgroundColor("#303030")
            .chartType(.line)
            .animationType(.bounce)
            .zoomType(.xy)
            .yAxisMin(yAxisMin)
            .yAxisMax(yAxixMax)
            .xAxisGridLineWidth(0.5)
            .yAxisGridLineWidth(0.5)
            .xAxisLabelsStyle(.init(color: "#ffffff"))
            .yAxisLabelsStyle(.init(color: "#ffffff"))
            .legendEnabled(true)
            .dataLabelsStyle(.init(color: "#ffffff", fontSize: 10.0))
            .dataLabelsEnabled(true)
//            .tooltipValueSuffix("YOP")//the value suffix of the chart tooltip
            .tooltipEnabled(false)
            .categories(categories)
            .colorsTheme([
                colorTheme
//                AAGradientColor.linearGradient(startColor: "#00ff00", endColor: "#ff0000")
//                AAGradientColor.oceanBlue,
//                AAGradientColor.sanguine,
//                AAGradientColor.lusciousLime,
//                AAGradientColor.mysticMauve
                ])
            .series([
                AASeriesElement()
                    .name(title)
                    .data(datas as [Any])
                    ])
        
        let chartOptions = chartModel.aa_toAAOptions()

        chartOptions.legend!
            .itemStyle(AAItemStyle()
                .color(AAColor.white))
        
        chartView.aa_drawChartWithChartOptions(chartOptions)
        
    }
    
}
