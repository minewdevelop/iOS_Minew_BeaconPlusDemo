//
//  ViewController.swift
//  BeaconPlusDemo
//
//  Created by Minewtech on 2019/4/18.
//  Copyright © 2019 Minewtech. All rights reserved.
//

import UIKit
import SnapKit
import MTBeaconPlus

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var manager = MTCentralManager.sharedInstance()!
    var scannerDevices : Array<MTPeripheral> = []
    var currentPeripheral:MTPeripheral?
    let tableView = UITableView()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        manager.stateBlock = { (state) in
            
            if state != .poweredOn {
                print("the iphone bluetooth state error")
            }
        }
        self.startScan()
        
        self.title = "Devices"
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(refreshViews), userInfo: nil, repeats: true)
                
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshViews() -> Void {
        self.title = "Devices(\(scannerDevices.count))"
        tableView.reloadData()
    }
    
    // MARK: ---------------------------tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannerDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "identifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: identifier)
        
        cell.textLabel?.text = scannerDevices[indexPath.row].framer.mac
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.connectDevice(peripheral: scannerDevices[indexPath.row])
    }
    // MARK: ---------------------------startScan

    func startScan() -> Void {
        manager.startScan { (devices) in
            self.scannerDevices = self.manager.scannedPeris
        }
    }
    // MARK: ---------------------------stopScan

    func stopScan() -> Void {
        manager.stopScan()
    }
    // MARK: ---------------------------connectDevice

    func connectDevice(peripheral : MTPeripheral) -> Void {
        peripheral.connector.statusChangedHandler = { (status, error) in
            
            if error != nil {
                print(error as Any)
            }
         
            switch status {
            case .StatusCompleted:
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                    
                    // After the connection
                    let tvc = DetailViewController()
                    tvc.device = peripheral
                    self.navigationController?.pushViewController( tvc, animated: true)
                })
                
                self.stopScan()
                
                break

            case .StatusDisconnected:
                
                print("disconnected")
                break
                
            case .StatusConnectFailed:
                
                print("connect failed")
                break
                
            case .StatusUndifined:
                break
                
            default:
                break
            }
        }
        
        manager.connect(toPeriperal:peripheral, passwordRequire: { (pass) in
            
            pass!("minew123")
        })
    }
    // MARK: ---------------------------disconnectDevice

    func disconnect(peripheral : MTPeripheral) -> Void {
        manager.disconnect(fromPeriperal: peripheral)
    }
    
}

