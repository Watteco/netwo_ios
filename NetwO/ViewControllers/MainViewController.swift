//
//  MainViewController.swift
//  NetwO
//
//  Created by Alain Grange on 07/05/2021.
//

import UIKit
import CoreBluetooth
import MBProgressHUD

class MainViewController: UIViewController, NavigationBarDelegate, MenuViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    var navigationBar: NavigationBar?
    let scanLabel = UILabel()
    let resultsTitleLabel = UILabel()
    var resultsTableView = UITableView()
    
    var peripherals = [CBPeripheral]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var navigationBarHeight: CGFloat = 70.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            navigationBarHeight = (window?.safeAreaInsets.top ?? 0.0) + 50.0
        }
        
        // background
        self.view.backgroundColor = ColorGrey
        
        // navigation bar
        navigationBar = NavigationBar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: navigationBarHeight))
        navigationBar?.autoresizingMask = .flexibleWidth
        navigationBar?.delegate = self
        self.view.addSubview(navigationBar!)
        
        // scan label
        scanLabel.frame = CGRect(x: 20.0, y: navigationBarHeight, width: self.view.frame.size.width - 40.0, height: self.view.frame.size.height - navigationBarHeight)
        scanLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scanLabel.textAlignment = .center
        scanLabel.font = UIFont.systemFont(ofSize: 16.0)
        scanLabel.textColor = ColorTextGreyLight
        scanLabel.text = NSLocalizedString("useScan", comment: "")
        self.view.addSubview(scanLabel)
        
        // results title label
        resultsTitleLabel.frame = CGRect(x: 0.0, y: navigationBarHeight, width: self.view.frame.size.width, height: 40.0)
        resultsTitleLabel.autoresizingMask = .flexibleWidth
        resultsTitleLabel.backgroundColor = ColorGreyMedium
        resultsTitleLabel.textAlignment = .center
        resultsTitleLabel.font = UIFont.systemFont(ofSize: 16.0)
        resultsTitleLabel.textColor = ColorTextGreyLight
        resultsTitleLabel.text = NSLocalizedString("devices", comment: "")
        resultsTitleLabel.isHidden = true
        self.view.addSubview(resultsTitleLabel)
        
        // results tableview
        resultsTableView = UITableView(frame: CGRect(x: 0.0, y: navigationBarHeight + 40.0, width: self.view.frame.size.width, height: self.view.frame.size.height - navigationBarHeight - 40.0), style: .plain)
        resultsTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        resultsTableView.isHidden = true
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.backgroundColor = .clear
        resultsTableView.separatorStyle = .singleLine
        resultsTableView.separatorColor = ColorTextGreyLight50
        self.view.addSubview(resultsTableView)
        
        resultsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // notifications
        NotificationCenter.default.addObserver(self, selector: #selector(bluetoothState), name: .BLEBluetoothState, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scanFinished), name: .BLEScanFinished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scanResults), name: .BLEScanResults, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceConnected), name: .BLEDeviceConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceFailedToConnect), name: .BLEDeviceFailedToConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDisconnected), name: .BLEDeviceDisconnected, object: nil)
        
    }

    deinit {
        
        NotificationCenter.default.removeObserver(self, name: .BLEBluetoothState, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BLEScanFinished, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BLEScanResults, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BLEDeviceConnected, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BLEDeviceFailedToConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: .BLEDeviceDisconnected, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // scan button
        navigationBar?.loadHomeLayout()
        navigationBar?.setScanButtonEnabled(enabled: NetwOBLE.shared.isBluetoothEnabled())
        
        NetwOBLE.shared.disconnect()
        
    }
    
    // MARK: - NavigationBar Delegate
    
    func scan(navigationBar: NavigationBar) {
        
        NetwOBLE.shared.disconnect()
        
        // scan
        NetwOBLE.shared.scan()

        navigationBar.setScanButtonEnabled(enabled: false)
        scanLabel.isHidden = false
        scanLabel.text = NSLocalizedString("scanning", comment: "")
        resultsTitleLabel.isHidden = true
        resultsTableView.isHidden = true
        
    }
    
    func menu(navigationBar: NavigationBar) {
        
        let menuViewController = MenuViewController()
        menuViewController.delegate = self
        menuViewController.terminalMenu = false
        menuViewController.modalPresentationStyle = .overCurrentContext
        present(menuViewController, animated: false, completion: nil)
        
    }
    
    // MARK: - MenuViewController Delegate
    
    func menuSelectItem(sendViewController: MenuViewController, action: String) {
        
        if action == "onlineSupport" {
            
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
            
        }
        
    }
    
    // MARK: - UITableView DataSource and Delegate
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        
        if (cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins))) {
            cell.preservesSuperviewLayoutMargins = false
        }

        if (cell.responds(to: #selector(setter: UIView.layoutMargins))) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        if tableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = .zero
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let PeripheralItemCellIdentifier = "PeripheralItemCellIdentifier"
        
        var cell: DeviceTableViewCell? = tableView.dequeueReusableCell(withIdentifier: PeripheralItemCellIdentifier) as? DeviceTableViewCell
        
        if cell == nil {
            cell = DeviceTableViewCell(style: .default, reuseIdentifier: PeripheralItemCellIdentifier)
        }
        
        let peripheral = peripherals[indexPath.row]
        
        cell?.loadWithPeripheral(peripheral: peripheral)
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // show loader
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // location permission
        _ = LocationHelper().location()
        
        NetwOBLE.shared.connectPeripheral(peripheral: peripherals[indexPath.row])
        
    }
    
    // MARK: - BLE Notifications
    
    @objc func bluetoothState(notification: NSNotification) {

        if notification.object != nil,
            let bluetoothEnabled = notification.object as? Bool {
            
            navigationBar?.setScanButtonEnabled(enabled: bluetoothEnabled)
            
        }

    }
        
    @objc func scanFinished() {
        navigationBar?.setScanButtonEnabled(enabled: NetwOBLE.shared.isBluetoothEnabled())
    }
    
    @objc func scanResults(notification: NSNotification) {
        
        if notification.object != nil,
            let scanPeripherals = notification.object as? [CBPeripheral: NSNumber] {
            
            if scanPeripherals.keys.isEmpty {
                scanLabel.isHidden = false
                scanLabel.text = NSLocalizedString("scanNoResult", comment: "")
            } else {
                
                scanLabel.isHidden = true
                resultsTitleLabel.isHidden = false
                resultsTableView.isHidden = false
                
                self.peripherals.removeAll()
                for peripheral in scanPeripherals.keys {
                    self.peripherals.append(peripheral)
                }
                resultsTableView.reloadData()
                
            }
            
        }
        
    }
    
    @objc func deviceConnected(notification: NSNotification) {
        
        // hide loader
        MBProgressHUD.hide(for: self.view, animated: true)
        
        if notification.object != nil,
            let peripheral = notification.object as? CBPeripheral {

            let terminalViewController = TerminalViewController()
            terminalViewController.device = peripheral
            self.navigationController?.pushViewController(terminalViewController, animated: true)

        }
        
    }
    
    @objc func deviceFailedToConnect(notification: NSNotification) {
        
        // hide loader
        MBProgressHUD.hide(for: self.view, animated: true)
        
    }
    
    @objc func deviceDisconnected(notification: NSNotification) {
        
        // hide loader
        MBProgressHUD.hide(for: self.view, animated: true)
        
    }
    
}

