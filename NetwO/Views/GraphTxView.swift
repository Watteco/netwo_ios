//
//  GraphTxView.swift
//  NetwO
//
//  Created by Alain Grange on 23/05/2021.
//

import UIKit
import AAInfographics

class GraphTxView: UIView {
    
    let percentageLabel = UILabel()
    let marginGraph = AAChartView()
    let marginNoDataLabel = UILabel()
    let sftxGraph = AAChartView()
    let sftxNoDataLabel = UILabel()
    let nbGatewaysGraph = AAChartView()
    let nbGatewaysNoDataLabel = UILabel()

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
        
        // margin graph
        marginGraph.frame = CGRect(x: 0.0, y: 0.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0 + 1.0)
        marginGraph.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        marginGraph.backgroundColor = ColorGrey
        marginGraph.scrollEnabled = false
        marginGraph.isHidden = true
        graphsView.addSubview(marginGraph)
        
        // margin no data label
        marginNoDataLabel.frame = CGRect(x: 0.0, y: 0.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0)
        marginNoDataLabel.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        marginNoDataLabel.textAlignment = .center
        marginNoDataLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
        marginNoDataLabel.textColor = ColorYellow
        marginNoDataLabel.text = NSLocalizedString("chartNoData", comment: "")
        graphsView.addSubview(marginNoDataLabel)
        
        // sftx graph
        sftxGraph.frame = CGRect(x: 0.0, y: graphsView.frame.size.height / 3.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0 + 1.0)
        sftxGraph.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        sftxGraph.backgroundColor = ColorGrey
        sftxGraph.scrollEnabled = false
        sftxGraph.isHidden = true
        graphsView.addSubview(sftxGraph)
        
        // sftx no data label
        sftxNoDataLabel.frame = CGRect(x: 0.0, y: graphsView.frame.size.height / 3.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0)
        sftxNoDataLabel.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        sftxNoDataLabel.textAlignment = .center
        sftxNoDataLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
        sftxNoDataLabel.textColor = ColorYellow
        sftxNoDataLabel.text = NSLocalizedString("chartNoData", comment: "")
        graphsView.addSubview(sftxNoDataLabel)
        
        // nb gateways graph
        nbGatewaysGraph.frame = CGRect(x: 0.0, y: (graphsView.frame.size.height / 3.0) * 2.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0 + 1.0)
        nbGatewaysGraph.autoresizingMask = [.flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        nbGatewaysGraph.backgroundColor = ColorGrey
        nbGatewaysGraph.scrollEnabled = false
        nbGatewaysGraph.isHidden = true
        graphsView.addSubview(nbGatewaysGraph)
        
        // nb gateways no data label
        nbGatewaysNoDataLabel.frame = CGRect(x: 0.0, y: (graphsView.frame.size.height / 3.0) * 2.0, width: graphsView.frame.size.width, height: graphsView.frame.size.height / 3.0)
        nbGatewaysNoDataLabel.autoresizingMask = [.flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        nbGatewaysNoDataLabel.textAlignment = .center
        nbGatewaysNoDataLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
        nbGatewaysNoDataLabel.textColor = ColorYellow
        nbGatewaysNoDataLabel.text = NSLocalizedString("chartNoData", comment: "")
        graphsView.addSubview(nbGatewaysNoDataLabel)
        
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
    
    func updateMargin(margins: [Int?]) {
        
        if margins.count > 0 {
            
            marginGraph.isHidden = false
            marginNoDataLabel.isHidden = true
            
            var categories = [String]()
            for i in 0..<margins.count {
                categories.append("\(i)")
            }
            
            var datas = [Int?]()
            for data in margins {
                datas.append(data)
            }
            
            generateGraph(chartView: marginGraph, title: "Margin", categories: categories, datas: datas, yAxisMin: 0.0, yAxixMax: 55.0, colorTheme: "#00d700")
            
        } else {
            marginGraph.isHidden = true
            marginNoDataLabel.isHidden = false
        }
        
    }
    
    func updateSFTX(sftx: [Int?]) {
        
        if sftx.count > 0 {
                
            sftxGraph.isHidden = false
            sftxNoDataLabel.isHidden = true
            
            var categories = [String]()
            for i in 0..<sftx.count {
                categories.append("\(i)")
            }
            
            var datas = [Int?]()
            for data in sftx {
                datas.append(data)
            }
            
            generateGraph(chartView: sftxGraph, title: "SFTX", categories: categories, datas: datas, yAxisMin: 6.0, yAxixMax: 13.0, colorTheme: "#8beafe")
        
        } else {
            sftxGraph.isHidden = true
            sftxNoDataLabel.isHidden = false
        }
        
    }
    
    func updateNbGateways(nbGateways: [Int?]) {
        
        if nbGateways.count > 0 {
            
            nbGatewaysGraph.isHidden = false
            nbGatewaysNoDataLabel.isHidden = true
            
            var categories = [String]()
            for i in 0..<nbGateways.count {
                categories.append("\(i)")
            }
            
            var datas = [Int?]()
            for data in nbGateways {
                datas.append(data)
            }
            
            generateGraph(chartView: nbGatewaysGraph, title: "Nb gateway", categories: categories, datas: datas, yAxisMin: 0.0, yAxixMax: 30.0, colorTheme: "#8beafe")
            
        } else {
            nbGatewaysGraph.isHidden = true
            nbGatewaysNoDataLabel.isHidden = false
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
