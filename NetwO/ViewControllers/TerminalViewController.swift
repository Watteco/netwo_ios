//
//  TerminalViewController.swift
//  NetwO
//
//  Created by Alain Grange on 08/05/2021.
//

import UIKit
import CoreBluetooth
import MBProgressHUD
import CoreLocation

class TerminalViewController: UIViewController, NavigationBarDelegate, SendViewControllerDelegate, MenuViewControllerDelegate, DebugViewDelegate, ConfigurationViewControllerDelegate, ReportViewControllerDelegate {
 
    var marginPerfect = 15, marginGood = 10, marginBad = 5, snrPerfect = -5, snrBad = -10, rssiPerfect = -107, rssiBad = -118
    
    var navigationBar: NavigationBar?
    let batteryImageView = UIImageView()
    let batteryLabel = UILabel()
    let operatorLabel = UILabel()
    let startTestRadioButton = UIButton()
    let gatewayLabel = UILabel()
    let operatorImageView = UIImageView()
    let tramesLabel = UILabel()
    let emissionLabel = UILabel()
    let emissionCheckImageView = UIImageView()
    let emissionMarginLabel = UILabel()
    let receptionLabel = UILabel()
    let receptionCheckImageView = UIImageView()
    let receptionRSSILabel = UILabel()
    let receptionSNRLabel = UILabel()
    var graphTxView = GraphTxView()
    var graphRxView = GraphRxView()
    var debugView = DebugView()
    
    var device: CBPeripheral?
    var datas = [String]()
    var reportDatas = [[String: Any?]]()
    var allTX = [String]()
    var allCurrentNumber = [String]()
    var allGateway = [Int?]()
    var allGatewayAvg = [Int?]()
    var allMargin = [Int?]()
    var allMarginAvg = [Int?]()
    var allSNR = [Int?]()
    var allSNRAvg = [Int?]()
    var allRSSI = [Int?]()
    var allRSSIAvg = [Int?]()
    var allSFTX = [Int?]()
    var allSFRX = [Int?]()
    var allWindows = [Int]()
    var allDelay = [Int]()
    var allOperator = [Int]()
    var allBatteryVoltage = [Float]()
    var allOperatorName = [Int: String?]()
    var appeui = String()
    var deveui = String()
    
    var datasCount = 0
    
    var paramSF = 0
    var paramNumber = 0
    var paramADR = 0
    
    var lastSend = String()
    var isWaitingX = false
    
    var lastNotification = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var navigationBarHeight: CGFloat = 70.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            navigationBarHeight = (window?.safeAreaInsets.top ?? 0.0) + 50.0
        }
        
        // operator names
        allOperatorName[0] = "private"
        allOperatorName[2] = "actility"
        allOperatorName[3] = "proximus"
        allOperatorName[4] = "swisscom"
        allOperatorName[7] = "objenious"
        allOperatorName[8] = "orbiwise"
        allOperatorName[10] = "kpn"
        allOperatorName[15] = "orange"
        allOperatorName[18] = "kerlink"
        allOperatorName[19] = "ttn"
        allOperatorName[21] = "cisco"
        allOperatorName[23] = "multitech"
        allOperatorName[24] = "loriot"
        allOperatorName[55] = "Tektelic"
        
        // background
        self.view.backgroundColor = ColorGrey
        
        var yPosition: CGFloat = 0.0
        
        // navigation bar
        navigationBar = NavigationBar(frame: CGRect(x: 0.0, y: yPosition, width: self.view.frame.size.width, height: navigationBarHeight))
        navigationBar?.autoresizingMask = .flexibleWidth
        navigationBar?.delegate = self
        self.view.addSubview(navigationBar!)
        
        yPosition += navigationBar!.frame.size.height + 10.0
        
        // battery imageview
        batteryImageView.frame = CGRect(x: 20.0, y: yPosition, width: 16.0, height: 16.0)
        batteryImageView.image = UIImage(named: "battery_missing")
        batteryImageView.contentMode = .scaleAspectFit
        self.view.addSubview(batteryImageView)
        
        // battery label
        batteryLabel.frame = CGRect(x: 60.0, y: yPosition, width: self.view.frame.size.width - 60.0, height: 16.0)
        batteryLabel.autoresizingMask = .flexibleWidth
        batteryLabel.textAlignment = .left
        batteryLabel.textColor = .white
        batteryLabel.font = UIFont.systemFont(ofSize: 10.0)
        self.view.addSubview(batteryLabel)
        
        // operator label
        operatorLabel.frame = CGRect(x: self.view.frame.size.width - 100.0, y: yPosition, width: 100.0, height: 16.0)
        operatorLabel.autoresizingMask = .flexibleLeftMargin
        operatorLabel.textAlignment = .center
        operatorLabel.textColor = .white
        operatorLabel.font = UIFont.systemFont(ofSize: 10.0)
        self.view.addSubview(operatorLabel)
        
        yPosition += batteryImageView.frame.size.height
        
        // start test radio button
        startTestRadioButton.frame = CGRect(x: 20.0, y: yPosition + 10.0, width: 100.0, height: 40.0)
        startTestRadioButton.addTarget(self, action: #selector(startTestRadioAction), for: .touchUpInside)
        startTestRadioButton.backgroundColor = ColorGreyMedium
        startTestRadioButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        startTestRadioButton.setTitleColor(.white, for: .normal)
        startTestRadioButton.setTitle(NSLocalizedString("receive", comment: ""), for: .normal)
        startTestRadioButton.alpha = 0.5
        startTestRadioButton.isEnabled = false
        self.view.addSubview(startTestRadioButton)
        
        // gateway label
        let gatewayLabelX = startTestRadioButton.frame.origin.x + startTestRadioButton.frame.size.width + 10.0
        
        gatewayLabel.frame = CGRect(x: gatewayLabelX, y: yPosition, width: self.view.frame.size.width - gatewayLabelX - 90.0, height: 60.0)
        gatewayLabel.autoresizingMask = .flexibleWidth
        gatewayLabel.textAlignment = .center
        gatewayLabel.textColor = .white
        gatewayLabel.numberOfLines = 0
        gatewayLabel.font = UIFont.systemFont(ofSize: 14.0)
        gatewayLabel.isUserInteractionEnabled = true
        self.view.addSubview(gatewayLabel)

        // gateway long press
        let gatewayLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(gatewayAction))
        gatewayLabel.addGestureRecognizer(gatewayLongPressRecognizer)
        
        // operator imageview
        operatorImageView.frame = CGRect(x: self.view.frame.size.width - 80.0, y: yPosition, width: 60.0, height: 60.0)
        operatorImageView.image = UIImage(named: "icon_antenna")
        operatorImageView.contentMode = .scaleAspectFit
        operatorImageView.isUserInteractionEnabled = true
        self.view.addSubview(operatorImageView)
        
        // operator long press
        let operatorLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(gatewayAction))
        operatorImageView.addGestureRecognizer(operatorLongPressRecognizer)
        
        yPosition += operatorImageView.frame.size.height + 10.0
        
        // emission view
        let heightLeft = self.view.frame.size.height - yPosition
        
        let emissionView = UIView(frame: CGRect(x: 15.0, y: yPosition, width: self.view.frame.size.width - 30.0, height: heightLeft / 2.0))
        emissionView.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        self.view.addSubview(emissionView)
        
        initEmissionView(emissionView: emissionView)
        
        // reception view
        let receptionView = UIView(frame: CGRect(x: 15.0, y: yPosition + (heightLeft / 2.0), width: self.view.frame.size.width - 30.0, height: heightLeft / 2.0))
        receptionView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        self.view.addSubview(receptionView)
        
        initReceptionView(receptionView: receptionView)
        
        // graph tx view
        self.graphTxView = GraphTxView(frame: CGRect(x: 0.0, y: navigationBarHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - navigationBarHeight))
        graphTxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        graphTxView.isHidden = true
        self.view.addSubview(graphTxView)
        
        // graph rx view
        self.graphRxView = GraphRxView(frame: CGRect(x: 0.0, y: navigationBarHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - navigationBarHeight))
        graphRxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        graphRxView.isHidden = true
        self.view.addSubview(graphRxView)
        
        // debug view
        self.debugView = DebugView(frame: CGRect(x: 0.0, y: navigationBarHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - navigationBarHeight))
        debugView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        debugView.delegate = self
        debugView.isHidden = true
        self.view.addSubview(debugView)
        
        // connect log
        status(value: "connected")
        
        // notifications
        NotificationCenter.default.addObserver(self, selector: #selector(collectDatas), name: .BLECollectDatas, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceConnected), name: .BLEDeviceConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceFailedToConnect), name: .BLEDeviceFailedToConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDisconnected), name: .BLEDeviceDisconnected, object: nil)
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: .BLECollectDatas, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BLEDeviceConnected, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BLEDeviceFailedToConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BLEDeviceDisconnected, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // navigation bar
        navigationBar?.loadTerminalLayout(title: device?.name)
        
    }
    
    func initEmissionView(emissionView: UIView) {
        
        // emission title label
        let emissionTitleLabel = UILabel()
        emissionTitleLabel.textAlignment = .left
        emissionTitleLabel.textColor = .white
        emissionTitleLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: NSLocalizedString("emission", comment: ""), attributes: underlineAttribute)
        emissionTitleLabel.attributedText = underlineAttributedString
        
        emissionTitleLabel.sizeToFit()
        emissionTitleLabel.frame = CGRect(x: 20.0, y: 0.0, width: emissionTitleLabel.frame.size.width, height: 20.0)
        
        emissionView.addSubview(emissionTitleLabel)
        
        // emission label
        let emissionLabelX = emissionTitleLabel.frame.origin.x + emissionTitleLabel.frame.size.width + 20.0
        
        emissionLabel.frame = CGRect(x: emissionLabelX, y: 0.0, width: 80.0, height: 20.0)
        emissionLabel.textAlignment = .left
        emissionLabel.textColor = .white
        emissionLabel.font = UIFont.systemFont(ofSize: 16.0)
        emissionLabel.isUserInteractionEnabled = true
        emissionView.addSubview(emissionLabel)
        
        // emission sf long press
        let sfLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(sfAction))
        emissionLabel.addGestureRecognizer(sfLongPressRecognizer)
        
        // trames label
        let tramesLabelX = emissionLabel.frame.origin.x + emissionLabel.frame.size.width
        
        tramesLabel.frame = CGRect(x: tramesLabelX, y: 0.0, width: 100.0, height: 20.0)
        tramesLabel.textAlignment = .left
        tramesLabel.textColor = .white
        tramesLabel.font = UIFont.systemFont(ofSize: 16.0)
        emissionView.addSubview(tramesLabel)
                
        // emission device imageview
        let emissionDeviceImageView = UIImageView(frame: CGRect(x: 0.0, y: 20.0, width: emissionView.frame.size.width / 3.0, height: emissionView.frame.size.height - 20.0))
        emissionDeviceImageView.autoresizingMask = [.flexibleRightMargin, .flexibleWidth, .flexibleHeight]
        emissionDeviceImageView.image = UIImage(named: "device")
        emissionDeviceImageView.contentMode = .scaleAspectFit
        emissionView.addSubview(emissionDeviceImageView)
        
        // emission check imageview
        emissionCheckImageView.frame = CGRect(x: emissionView.frame.size.width / 3.0, y: 20.0, width: emissionView.frame.size.width / 3.0, height: emissionView.frame.size.height - 20.0)
        emissionCheckImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
        emissionCheckImageView.image = UIImage(named: "wifi_question_mark")
        emissionCheckImageView.contentMode = .scaleAspectFit
        emissionCheckImageView.isUserInteractionEnabled = true
        emissionView.addSubview(emissionCheckImageView)
        
        // emission check long press
        let emissionCheckLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(emissionCheckAction))
        emissionCheckImageView.addGestureRecognizer(emissionCheckLongPressRecognizer)
        
        // emission margin label
        emissionMarginLabel.frame = CGRect(x: emissionView.frame.size.width / 3.0 * 2.0, y: 20.0, width: emissionView.frame.size.width / 3.0, height: emissionView.frame.size.height - 20.0)
        emissionMarginLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleHeight]
        emissionMarginLabel.numberOfLines = 0
        emissionMarginLabel.textAlignment = .center
        emissionMarginLabel.textColor = .white
        emissionMarginLabel.font = UIFont.systemFont(ofSize: 16.0)
        emissionMarginLabel.isUserInteractionEnabled = true
        emissionView.addSubview(emissionMarginLabel)
        
        // emission margin long press
        let marginLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(marginAction))
        emissionMarginLabel.addGestureRecognizer(marginLongPressRecognizer)
        
    }
    
    func initReceptionView(receptionView: UIView) {
        
        // reception title label
        let receptionTitleLabel = UILabel()
        receptionTitleLabel.textAlignment = .left
        receptionTitleLabel.textColor = .white
        receptionTitleLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: NSLocalizedString("reception", comment: ""), attributes: underlineAttribute)
        receptionTitleLabel.attributedText = underlineAttributedString
        
        receptionTitleLabel.sizeToFit()
        receptionTitleLabel.frame = CGRect(x: 20.0, y: 0.0, width: receptionTitleLabel.frame.size.width, height: 20.0)
        
        receptionView.addSubview(receptionTitleLabel)
        
        // reception label
        let receptionLabelX = receptionTitleLabel.frame.origin.x + receptionTitleLabel.frame.size.width + 20.0
        
        receptionLabel.frame = CGRect(x: receptionLabelX, y: 0.0, width: receptionView.frame.size.width - receptionLabelX, height: 20.0)
        receptionLabel.autoresizingMask = .flexibleWidth
        receptionLabel.textAlignment = .left
        receptionLabel.textColor = .white
        receptionLabel.font = UIFont.systemFont(ofSize: 16.0)
        receptionLabel.isUserInteractionEnabled = true
        receptionView.addSubview(receptionLabel)
        
        // reception long press
        let receptionLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(receptionAction))
        receptionLabel.addGestureRecognizer(receptionLongPressRecognizer)
        
        // reception device imageview
        let receptionDeviceImageView = UIImageView(frame: CGRect(x: 0.0, y: 20.0, width: receptionView.frame.size.width / 3.0, height: receptionView.frame.size.height - 20.0))
        receptionDeviceImageView.autoresizingMask = [.flexibleRightMargin, .flexibleWidth, .flexibleHeight]
        receptionDeviceImageView.image = UIImage(named: "device")
        receptionDeviceImageView.contentMode = .scaleAspectFit
        receptionView.addSubview(receptionDeviceImageView)
        
        // reception check imageview
        receptionCheckImageView.frame = CGRect(x: receptionView.frame.size.width / 3.0, y: 20.0, width: receptionView.frame.size.width / 3.0, height: receptionView.frame.size.height - 20.0)
        receptionCheckImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
        receptionCheckImageView.image = UIImage(named: "wifi_question_mark_flipped")
        receptionCheckImageView.contentMode = .scaleAspectFit
        receptionCheckImageView.isUserInteractionEnabled = true
        receptionView.addSubview(receptionCheckImageView)
        
        // reception check long press
        let receptionCheckLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(receptionCheckAction))
        receptionCheckImageView.addGestureRecognizer(receptionCheckLongPressRecognizer)
        
        // reception values view
        let receptionValuesView = UIView(frame: CGRect(x: receptionView.frame.size.width / 3.0 * 2.0, y: 20.0, width: receptionView.frame.size.width / 3.0, height: receptionView.frame.size.height - 20.0))
        receptionValuesView.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleHeight]
        receptionView.addSubview(receptionValuesView)
        
        // reception rssi label
        receptionRSSILabel.frame = CGRect(x: 0.0, y: 0.0, width: receptionValuesView.frame.size.width, height: receptionValuesView.frame.size.height / 2.0)
        receptionRSSILabel.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        receptionRSSILabel.numberOfLines = 0
        receptionRSSILabel.textAlignment = .center
        receptionRSSILabel.textColor = .white
        receptionRSSILabel.font = UIFont.systemFont(ofSize: 16.0)
        receptionRSSILabel.isUserInteractionEnabled = true
        receptionValuesView.addSubview(receptionRSSILabel)
        
        // reception rssi long press
        let rssiLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(rssiAction))
        receptionRSSILabel.addGestureRecognizer(rssiLongPressRecognizer)
        
        // reception snr label
        receptionSNRLabel.frame = CGRect(x: 0.0, y: receptionValuesView.frame.size.height / 2.0, width: receptionValuesView.frame.size.width, height: receptionValuesView.frame.size.height / 2.0)
        receptionSNRLabel.autoresizingMask = [.flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        receptionSNRLabel.numberOfLines = 0
        receptionSNRLabel.textAlignment = .center
        receptionSNRLabel.textColor = .white
        receptionSNRLabel.font = UIFont.systemFont(ofSize: 16.0)
        receptionSNRLabel.isUserInteractionEnabled = true
        receptionValuesView.addSubview(receptionSNRLabel)
        
        // reception snr long press
        let snrLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(snrAction))
        receptionSNRLabel.addGestureRecognizer(snrLongPressRecognizer)
        
    }
    
    func send(value: String) {
        
        if !NetwOBLE.shared.isConnected() {
            Utils.showAlert(view: self.view, message: NSLocalizedString("device_not_connected", comment: ""))
            return
        }
        
        NetwOBLE.shared.startTest(value: "\(value)\r\n")
        
        let mutableAttributedString = NSMutableAttributedString.init(string: "\(value)\n")
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorBlueLight, range: NSMakeRange(0, value.count))
        debugView.appendValue(attributedString: mutableAttributedString)
        
    }
    
    func status(value: String) {
        
        let mutableAttributedString = NSMutableAttributedString.init(string: "\(value)\n")
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorYellow, range: NSMakeRange(0, value.count))
        debugView.appendValue(attributedString: mutableAttributedString)
        
    }
    
    func parseData(value: String) {
                
        let lines = value.components(separatedBy: "\n")
        
        if lines.count < 11 {
            
            for line in lines {
                                
                if line.contains("TX") && line.contains("/") {
                    
                    allTX.append(line)

                    if let lastTX = allTX.last {
                        tramesLabel.text = lastTX
                    }
                    
                    datasCount += 1
                                        
                    break
                    
                }else if line.contains("APPEUI") {
                    let appeuiIndex = line.index(line.startIndex, offsetBy: 7)
                    appeui = String(line.suffix(from: appeuiIndex))
                }else if line.contains("DEVEUI") {
                    let deveuiIndex = line.index(line.startIndex, offsetBy: 7)
                    deveui = String(line.suffix(from: deveuiIndex))
                    
                    startTestRadioButton.alpha = 1
                    startTestRadioButton.isEnabled = true
                    
                    changeTitle(title: deveui)
                }
            }

        } else if lines.count >= 11 && value != "\n" && !lines[1].contains("RESULT") {
            
            allCurrentNumber.append(lines[0])
            if let lastNumber = allCurrentNumber.last,
               let index = Int(lastNumber.split(separator: "/")[1]) {
                
                fillDatasIfNeeded(index: index, datas: &allGateway, initialCount: datasCount)
                fillDatasIfNeeded(index: index, datas: &allMargin, initialCount: datasCount)
                fillDatasIfNeeded(index: index, datas: &allSFTX, initialCount: datasCount)
                fillDatasIfNeeded(index: index, datas: &allSNR, initialCount: datasCount)
                fillDatasIfNeeded(index: index, datas: &allRSSI, initialCount: datasCount)
                fillDatasIfNeeded(index: index, datas: &allSFRX, initialCount: datasCount)

                allGateway.append(Int(lines[1].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
                allMargin.append(Int(lines[2].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
                allSFTX.append(Int(lines[3].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
                allSNR.append(Int(lines[4].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
                allRSSI.append(Int(lines[5].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
                allWindows.append(Int(lines[6].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
                allSFRX.append(Int(lines[7].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
                allDelay.append(Int(lines[8].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
                let battery = (Float(lines[9].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0) / 100.0
                allBatteryVoltage.append(battery / 10.0)
                allOperator.append(Int(lines[10].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
                
                // export datas
                addReportData()
                
                // update graphs
                updateGraphs()
                
                displayPercentageOfDataReceived()
                displaySimplifiedData(isAverage: false)
                    
            }
                        
        } else if lines[1].contains("RESULT") {
            print("Average")
            allGatewayAvg.append(Int(lines[4].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
            allMarginAvg.append(Int(lines[5].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
            allSNRAvg.append(Int(lines[6].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
            allRSSIAvg.append(Int(lines[7].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
            displaySimplifiedData(isAverage: true)
            
        }
        
        displayIndicatorOfBattery()
        
    }
    
    func addReportData() {

        let userLocation = LocationHelper().location()
        
        var temp = [String: Any?]()
        
        temp["Date"] = Formatters.stringFromDate(from: Date(), template: FormattersTemplate.ddMMyyyyHHmmss)!
        
        if userLocation != nil,
           let lat = userLocation?.coordinate.latitude,
           let lon = userLocation?.coordinate.longitude {
            
            temp["Latitude"] = "\(lat)"
            temp["Longitude"] = "\(lon)"
            
        } else {
            temp["Latitude"] = "/"
            temp["Longitude"] = "/"
        }
        
        temp["Gateway"] = allGateway.last
        temp["Margin"] = allMargin.last
        temp["SFTX"] = allSFTX.last
        temp["SNR"] = allSNR.last
        temp["RSSI"] = allRSSI.last
        temp["Windows"] = allWindows.last
        temp["SFRX"] = allSFRX.last
        temp["Delay"] = allDelay.last
        temp["OperatorIndex"] = allOperator.last
        temp["OperatorName"] = allOperatorName[allOperator.last ?? -1] ?? "Unknown"
        
        reportDatas.append(temp)
        
    }
    
    func updateGraphs() {
        
        graphTxView.updateMargin(margins: allMargin)
        graphTxView.updateSFTX(sftx: allSFTX)
        graphTxView.updateNbGateways(nbGateways: allGateway)
        
        graphRxView.updateSNR(snr: allSNR)
        graphRxView.updateRSSI(rssi: allRSSI)
        graphRxView.updateSFRX(sfrx: allSFRX)
        
    }
    
    func displayIndicatorOfBattery() {
        
        if allBatteryVoltage.count > 0, let lastBatteryVoltage = allBatteryVoltage.last {
            
            batteryLabel.text = "Battery Voltage = \(String(format: "%.1f", lastBatteryVoltage))V"
            
            if lastBatteryVoltage >= 2.8 {
                batteryImageView.image = UIImage(named: "battery_full")
            } else if lastBatteryVoltage >= 2.4 {
                batteryImageView.image = UIImage(named: "battery_half")
            } else if lastBatteryVoltage >= 2.0 {
                batteryImageView.image = UIImage(named: "battery_weak")
            } else {
                batteryImageView.image = UIImage(named: "battery_empty")
            }
            
        } else {
            batteryLabel.text = "Battery Voltage = 3.6V"
            batteryImageView.image = UIImage(named: "battery_missing")
        }
        
    }
    
    func displayPercentageOfDataReceived() {
        
        if let lastCurrentNumber = allCurrentNumber.last,
           let a = Int(lastCurrentNumber.split(separator: "/")[1]),
           let b = Int(lastCurrentNumber.split(separator: "/")[0]) {
            
            let percentage = roundf(100.0 * Float(b) / Float(a))
            
            graphTxView.setPercentage(percentage: percentage)
            graphRxView.setPercentage(percentage: percentage)
            
        }
        
    }
    
    func displaySimplifiedData(isAverage: Bool) {
        
        if let lastMargin = allMargin.last,
           let lastRSSI = allRSSI.last,
           let lastSNR = allSNR.last,
           let lastSFTX = allSFTX.last,
           let lastSFRX = allSFRX.last,
           let lastGateway = allGateway.last,
           let lastWindow = allWindows.last,
           let lastDelay = allDelay.last,
           let lastOperator = allOperator.last,
           let lastOperatorName = allOperatorName[lastOperator] ?? "" {
            
            if isAverage {
                
                if let lastGatewayAvg : Int? = allGatewayAvg.last,
                   let lastSNRAvg : Int?  = allSNRAvg.last,
                   let lastMarginAvg : Int?  = allMarginAvg.last,
                   let lastRSSIAvg : Int?  = allRSSIAvg.last {
                    
                    gatewayLabel.text = "\(NSLocalizedString("averageGateway", comment: ""))\(String(describing: lastGatewayAvg ?? 0))"
                    receptionSNRLabel.text = "\(NSLocalizedString("average", comment: "")) SNR\n\(String(describing: lastSNRAvg ?? 0)) dB"
                    emissionMarginLabel.text = "\(NSLocalizedString("average", comment: "")) Margin\n\(String(describing: lastMarginAvg ?? 0)) dB"
                    receptionRSSILabel.text = "\(NSLocalizedString("average", comment: "")) RSSI\n\(String(describing: lastRSSIAvg ?? 0)) dBm"
                }
                
               
                
            } else {
                
                if lastGateway ?? 0 > 1 {
                    gatewayLabel.text = "\(NSLocalizedString("thereAre", comment: "")) \(lastGateway ?? 0) \(NSLocalizedString("gateways", comment: ""))"
                } else {
                    gatewayLabel.text = "\(NSLocalizedString("thereIs", comment: "")) \(lastGateway ?? 0) \(NSLocalizedString("gateway", comment: ""))"
                }
                receptionSNRLabel.text = "SNR\n\(lastSNR ?? 0) dB"
                emissionMarginLabel.text = "Margin\n\(lastMargin ?? 0) dB"
                receptionRSSILabel.text = "RSSI\n\(lastRSSI ?? 0) dBm"
                operatorLabel.text = lastOperatorName
                
            }
            
            if lastGateway == 1 {
                gatewayLabel.textColor = .red
            } else if lastGateway == 2 || lastGateway == 3 {
                gatewayLabel.textColor = .orange
            } else {
                gatewayLabel.textColor = .white
            }
            
            emissionLabel.text = "SF\(lastSFTX ?? 0)"
            receptionLabel.text = "SF\(lastSFRX ?? 0) RX\(lastWindow) \(lastDelay)s"
            
            if let lastMargin = lastMargin {
                if lastMargin >= marginPerfect {
                    emissionCheckImageView.image = UIImage(named: "wifi_perfect_green")
                } else if lastMargin >= marginGood {
                    emissionCheckImageView.image = UIImage(named: "wifi_good_light_green")
                } else if lastMargin >= marginBad {
                    emissionCheckImageView.image = UIImage(named: "wifi_bad_orange")
                } else {
                    emissionCheckImageView.image = UIImage(named: "wifi_terribe_red")
                }
            } else {
                emissionCheckImageView.image = UIImage(named: "wifi_terribe_red")
            }
            
            if let lastRSSI = lastRSSI, let lastSNR = lastSNR {
                if lastRSSI >= rssiPerfect && lastSNR >= snrPerfect {
                    receptionCheckImageView.image = UIImage(named: "wifi_perfect_green")
                } else if (lastRSSI >= rssiPerfect && lastSNR >= snrBad) || (lastSNR >= snrPerfect && lastRSSI >= rssiBad) {
                    receptionCheckImageView.image = UIImage(named: "wifi_good_light_green")
                } else if (lastRSSI >= rssiBad && lastSNR <= snrBad) || (lastRSSI <= rssiBad && lastSNR >= snrBad) || (lastRSSI <= rssiPerfect && lastRSSI >= rssiBad) {
                    receptionCheckImageView.image = UIImage(named: "wifi_bad_orange")
                } else {
                    receptionCheckImageView.image = UIImage(named: "wifi_terribe_red")
                }
            } else {
                receptionCheckImageView.image = UIImage(named: "wifi_terribe_red")
            }
            receptionCheckImageView.transform = .init(rotationAngle: .pi)
            
        }
        
    }
    
    func fillDatasIfNeeded(index: Int, datas: inout [Int?], initialCount: Int) {
        
        while datas.count < initialCount - 1 {
            datas.append(nil)
        }
        
    }
    
    // MARK: - Actions
    
    @objc func startTestRadioAction() {
        
        let sendViewController = SendViewController()
        sendViewController.delegate = self
        sendViewController.deveui = deveui
        sendViewController.modalPresentationStyle = .overCurrentContext
        present(sendViewController, animated: false, completion: nil)
        
    }
    
    @objc func gatewayAction() {
        
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.setText(text: NSLocalizedString("descriptionGateway", comment: ""))
        present(infoViewController, animated: false, completion: nil)
        
    }
    
    @objc func marginAction() {
        
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.setText(text: NSLocalizedString("descriptionMargin", comment: ""))
        present(infoViewController, animated: false, completion: nil)
        
    }
    
    @objc func rssiAction() {
        
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.setText(text: NSLocalizedString("descriptionRSSI", comment: ""))
        present(infoViewController, animated: false, completion: nil)
        
    }
    
    @objc func snrAction() {
        
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.setText(text: NSLocalizedString("descriptionSNR", comment: ""))
        present(infoViewController, animated: false, completion: nil)
        
    }
    
    @objc func sfAction() {
        
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.setText(text: NSLocalizedString("descriptionSF", comment: ""))
        present(infoViewController, animated: false, completion: nil)
        
    }
    
    @objc func receptionAction() {
        
        var infoString = NSLocalizedString("descriptionSF", comment: "")
        infoString += "\n"
        infoString += NSLocalizedString("descriptionRX", comment: "")
        infoString += "\n"
        infoString += NSLocalizedString("descriptionDelay", comment: "")
                
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.setText(text: infoString)
        present(infoViewController, animated: false, completion: nil)
        
    }
    
    @objc func emissionCheckAction() {
        
        var infoString = "Margin >= "
        infoString += "\(marginPerfect)"
        infoString += " -> "
        infoString += NSLocalizedString("perfect", comment: "")
        infoString += "\n"
        infoString += "\(marginPerfect)"
        infoString += " > Margin >= "
        infoString += "\(marginGood)"
        infoString += "-> "
        infoString += NSLocalizedString("excellent", comment: "")
        infoString += "\n"
        infoString += "\(marginGood)"
        infoString += " > Margin >= "
        infoString += "\(marginBad)"
        infoString += " -> "
        infoString += NSLocalizedString("good", comment: "")
        infoString += "\n"
        infoString += "\(marginBad)"
        infoString += " >= Margin -> "
        infoString += NSLocalizedString("bad", comment: "")
        
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.setText(text: infoString)
        present(infoViewController, animated: false, completion: nil)
        
    }
    
    @objc func receptionCheckAction() {
                
        var infoString = "A:"
        infoString += "\(snrPerfect)"
        infoString += "\nB:"
        infoString += "\(snrBad)"
        infoString += "\nC:"
        infoString += "\(rssiBad)"
        infoString += "\nD:"
        infoString += "\(rssiPerfect)"
        
        let infoViewController = InfoViewController(image: UIImage(named: "rssi_snr"))
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.setText(text: infoString)
        present(infoViewController, animated: false, completion: nil)
        
    }
    
    func exportDatasAction(type: String, filename: String) {
        
        // show loader
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            DispatchQueue.global(qos: .background).async {

                var exportData: Data?
                if type == "json" {
                    exportData = JSONHelper.generateJSON(reportDatas: self.reportDatas)
                } else if type == "csv" {
                    exportData = CSVHelper.generateCSV(reportDatas: self.reportDatas)
                } else {
                    exportData = nil
                }

                if exportData == nil {
                    
                    let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("please_try_again_later", comment: ""), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: {
                        action in
                        
                        }
                    ))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    let documents = FileManager.default.urls(
                        for: .documentDirectory,
                        in: .userDomainMask
                    ).first

                    let finalFileName = "\(filename).\(type)"
                       
                    guard let path = documents?.appendingPathComponent("/\(finalFileName)") else {
                       
                       let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("please_try_again_later", comment: ""), preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: {
                           action in
                           
                           }
                       ))
                       self.present(alert, animated: true, completion: nil)
                       
                       return
                       
                    }
                     
                    do {
                       
                       try exportData!.write(to: path, options: .atomicWrite)
                       
                       let activity = UIActivityViewController(
                            activityItems: [path],
                            applicationActivities: nil
                       )

                        DispatchQueue.main.async {

                            // hide loader
                            MBProgressHUD.hide(for: self.view, animated: true)

                            self.present(activity, animated: true, completion: nil)
                            
                        }
                       
                    } catch {
                       
                       let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("please_try_again_later", comment: ""), preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: {
                           action in
                           
                           }
                       ))
                       self.present(alert, animated: true, completion: nil)
                                               
                    }
                    
                }
                    
            }
            
        }
        
    }
    
    // MARK: - NavigationBar Delegate
    
    func delete(navigationBar: NavigationBar) {
        
        let confirmAlert = UIAlertController(title: "Suppression", message: "Confirmez-vous la réinitialisation ?", preferredStyle: .alert)
        confirmAlert.addAction(UIAlertAction(title: "Supprimer", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            let clearString = "~\(NSLocalizedString("clear", comment: ""))~\n"
            let mutableAttributedString = NSMutableAttributedString.init(string: clearString)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, clearString.count))
            self.debugView.setValue(attributedString: mutableAttributedString)

            self.receptionRSSILabel.text = "RSSI"
            self.emissionMarginLabel.text = "Margin"
            self.receptionSNRLabel.text = "SNR"
            self.emissionLabel.text = "SF :"
            self.receptionLabel.text = ""
            self.gatewayLabel.text = ""
            self.operatorLabel.text = ""
            self.tramesLabel.text = ""
            
            self.receptionCheckImageView.image = UIImage(named: "wifi_question_mark_flipped")
            self.receptionCheckImageView.transform = .init(rotationAngle: 0)
            self.emissionCheckImageView.image = UIImage(named: "wifi_question_mark")
            self.batteryLabel.text = ""
            self.batteryImageView.image = UIImage(named: "battery_missing")
            
            self.datas.removeAll()
            self.reportDatas.removeAll()
            self.allCurrentNumber.removeAll()
            self.allTX.removeAll()
            self.allGateway.removeAll()
            self.allMargin.removeAll()
            self.allSNR.removeAll()
            self.allRSSI.removeAll()
            self.allSFTX.removeAll()
            self.allSFRX.removeAll()
            self.allWindows.removeAll()
            self.allDelay.removeAll()
            self.allOperator.removeAll()
            self.allBatteryVoltage.removeAll()
            
            self.datasCount = 0
            
            self.graphTxView.setPercentage(percentage: 0.0)
            self.graphRxView.setPercentage(percentage: 0.0)
            self.updateGraphs()
            
        }))
        confirmAlert.addAction(UIAlertAction(title: "Annuler", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    func changeTitle(title : String) {
        navigationBar?.setTitle(title: "WTC-\(String(title.suffix(8)))")
    }
    
    func simple(navigationBar: NavigationBar) {
        
        operatorLabel.isHidden = false
        graphTxView.isHidden = true
        graphRxView.isHidden = true
        debugView.isHidden = true
        
    }
    
    func graphTx(navigationBar: NavigationBar) {
        
        operatorLabel.isHidden = true
        graphTxView.isHidden = false
        graphRxView.isHidden = true
        debugView.isHidden = true
        
    }
    
    func graphRx(navigationBar: NavigationBar) {
        
        operatorLabel.isHidden = true
        graphTxView.isHidden = true
        graphRxView.isHidden = false
        debugView.isHidden = true
        
    }
    
    func menu(navigationBar: NavigationBar) {
        
        let menuViewController = MenuViewController()
        menuViewController.delegate = self
        menuViewController.terminalMenu = true
        menuViewController.modalPresentationStyle = .overCurrentContext
        present(menuViewController, animated: false, completion: nil)
        
    }
    
    // MARK: - SendViewController Delegate
    
    @objc func sendValues(sendViewController: SendViewController, list: [Int]) {
        
        if list.count != 3 {
            return
        }
        
        paramSF = list[0]
        paramNumber = list[1]
        paramADR = list[2]
        
        let value = "S\(paramNumber),\(paramSF),\(paramADR)"
        send(value: value)
        
        lastSend = "S"
                
    }
    
    @objc func updateDeveuiIndex(sendViewController: SendViewController, index: String) {
    
        if !NetwOBLE.shared.isConnected() {
            Utils.showAlert(view: self.view, message: NSLocalizedString("device_not_connected", comment: ""))
            return
        }
        NetwOBLE.shared.updateDeveuiIndex(index: "\(index)")
        
        lastSend = "M"
    }
    
    // MARK: - MenuViewController Delegate
    
    func menuSelectItem(sendViewController: MenuViewController, action: String) {
        
        if action == "debug" {
            
            graphTxView.isHidden = true
            graphRxView.isHidden = true
            debugView.isHidden = false
        
        } else if action == "onlineSupport" {
            
            if let url = URL(string: "https://support.nke-watteco.com/netwo/") {
                UIApplication.shared.open(url)
            }
            
        } else if action == "about" {
            
            let infoViewController = InfoViewController()
            infoViewController.modalPresentationStyle = .overCurrentContext
            
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                infoViewController.setText(text: NSLocalizedString("aboutText", comment: "").replacingOccurrences(of: "{{0}}", with: appVersion))
            }
            
            present(infoViewController, animated: false, completion: nil)
            
        } else if action == "configuration" {
            
            let configurationViewController = ConfigurationViewController()
            configurationViewController.delegate = self
            configurationViewController.marginPerfect = marginPerfect
            configurationViewController.marginGood = marginGood
            configurationViewController.marginBad = marginBad
            configurationViewController.rssiPerfect = rssiPerfect
            configurationViewController.rssiBad = rssiBad
            configurationViewController.snrPerfect = snrPerfect
            configurationViewController.snrBad = snrBad
            configurationViewController.modalPresentationStyle = .overCurrentContext
            present(configurationViewController, animated: false, completion: nil)
            
        } else if action == "report" {
            
            let reportViewController = ReportViewController()
            reportViewController.delegate = self
            let dateString = Formatters.stringFromDate(from: Date(), template: FormattersTemplate.ddMMyyyyHHmmss)!
            reportViewController.filename = "report_\(self.device?.name ?? "device")_\(dateString)"
            reportViewController.modalPresentationStyle = .overCurrentContext
            present(reportViewController, animated: false, completion: nil)
            
        } else if action == "scanBle" {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    // MARK: - DebugView Delegate
    
    func sendFromDebugView(debugView: DebugView, value: String) {
        
        if value.count == 0 {
            return
        }
        
        send(value: value)
    
    }
    
    // MARK: - ConfigurationViewController Delegate
    
    func applyConfiguration(configurationViewController: ConfigurationViewController, list: [Int]) {
        
        if list.count != 7 {
            return
        }
        
        marginPerfect = list[0]
        marginGood = list[1]
        marginBad = list[2]
        rssiPerfect = list[3]
        rssiBad = list[4]
        snrPerfect = list[5]
        snrBad = list[6]
        
    }
    
    // MARK: - ReportViewController Delegate
    
    func selectReport(reportViewController: ReportViewController, action: String, filename: String) {
        exportDatasAction(type: action, filename: filename)
    }
    
    // MARK: - BLE Notifications
    
    @objc func collectDatas(notification: NSNotification) {
        
        if notification.object != nil,
            let datasString = notification.object as? String {
            
            if(datasString != lastNotification){
                print("collect datas : <\(datasString) >")
                
                datas.append(datasString)
                
                // debug
                let mutableAttributedString = NSMutableAttributedString.init(string: datasString)
                mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSMakeRange(0, datasString.count))
                debugView.appendValue(attributedString: mutableAttributedString)
                
                if datasString.contains("NOK") {
                    switch lastSend {
                        case "S":
                            if(!isWaitingX){
                                Utils.showAlert(view: self.view, message: "Waiting")
                                send(value: "X")
                                
                                isWaitingX = true
                                lastSend = "X"
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
                                    let value = "S\(paramNumber),\(paramSF),\(self.paramADR)"
                                    self.send(value: value)
                                    self.lastSend = "S"
                                 }
                            }
                            break
                        case "X":
                            Utils.showAlert(view: self.view, message: "Not ok")
                            send(value: "X")
                            
                            isWaitingX = true
                            lastSend = "X"
                            break
                        default:
                            Utils.showAlert(view: self.view, message: "Not ok")
                    }
                } else if datasString.contains("OK") {
                    if(lastSend == "S"){
                        isWaitingX = false
                    }
                    if(isWaitingX) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
                            let value = "S\(paramNumber),\(paramSF),\(self.paramADR)"
                            self.send(value: value)
                            self.lastSend = "S"
                         }
                    }else{
                        Utils.showAlert(view: self.view, message: "Ok")
                    }
                    } else {
                        parseData(value: datasString)
                    }
            }
            lastNotification = datasString
        }
        
    }
    
    @objc func deviceConnected(notification: NSNotification) {
        status(value: "connected")
    }
    
    @objc func deviceFailedToConnect(notification: NSNotification) {
        status(value: "connection failed")
    }
    
    @objc func deviceDisconnected(notification: NSNotification) {
        status(value: "connection lost")
    }
}
