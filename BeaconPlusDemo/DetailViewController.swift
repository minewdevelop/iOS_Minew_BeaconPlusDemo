//
//  DetailViewController.swift
//  BeaconPlusDemo
//
//  Created by Minewtech on 2020/11/26.
//  Copyright © 2020 Minewtech. All rights reserved.
//

import UIKit
import MTBeaconPlus

class DetailViewController: UIViewController {
    var device: MTPeripheral?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = device?.framer.mac
        self.getAllBroadcast()
        self.getAllSlot()
        self.getTrigger()
        // Do any additional setup after loading the view.
    }
    func getAllBroadcast() -> Void {
        for frame in (device?.framer.advFrames)! {
            self.getBroadcastFrame(frame: frame)
        }
    }
    
    func getAllSlot() -> Void {
        for frame in (device?.connector.allFrames)! {
            self.getSlotFrame(frame: frame)
        }
    }
    
    func getBroadcastFrame(frame:MinewFrame) -> Void {
        switch frame.frameType {
        case .FrameiBeacon:
            let iBeacon = frame as! MinewiBeacon
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd' at 'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: iBeacon.lastUpdate) as String
            
            print("iBeacon:\(iBeacon.major)--\(String(describing: iBeacon.uuid))--\( iBeacon.minor)--\(strNowTime)")
            break
        case .FrameURL:
            let url = frame as! MinewURL
            print("URL:\(url.urlString ?? "nil")--\(233)")
            break
        case .FrameUID:
            let uid = frame as! MinewUID
            print("UID:\(uid.namespaceId ?? "nil")--\(uid.instanceId ?? "nil")")
            break
        case .FrameTLM:
            let tlm = frame as! MinewTLM

            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd' at 'HH:mm:ss"
            let strNowTime = timeFormatter.string(from: tlm.lastUpdate) as String
            
            print("TLM--\(strNowTime)")
            break
        case .FrameDeviceInfo:
            print("DeviceInfo")
            break
        // LineBeacon
        case .FrameLineBeacon:
            let lineBeaconData = frame as! MinewLineBeacon
            print("LineBeacon:\(lineBeaconData.hwId)")
            break
        
        default:
            print("Unauthenticated Frame")
            break
        }
    }
    
    func getSlotFrame(frame:MinewFrame) -> Void {
                
        switch frame.frameType {
        case .FrameiBeacon:
            let iBeacon = frame as! MinewiBeacon
            print("iBeacon:\(iBeacon.major)--\(String(describing: iBeacon.uuid))--\( iBeacon.minor)")
            break
        case .FrameURL:
            let url = frame as! MinewURL
            print("SlotFrame---URL:\(url.urlString ?? "nil")")
            break
        case .FrameUID:
            let uid = frame as! MinewUID
            print("SlotFrame---UID:\(uid.namespaceId ?? "nil")--\(uid.instanceId ?? "nil")")
            break
        case .FrameTLM:
            print("SlotFrame---TLM")
            break
        case .FrameDeviceInfo:
            print("SlotFrame---DeviceInfo")
            break
        // LineBeacon
        case .FrameLineBeacon:
            let lineBeaconData = device?.connector.slotHandler.slotFrameDataDic[FrameTypeString(FrameType.FrameLineBeacon)!] as? MTLineBeaconData
            print("SlotFrame---LineBeacon:\(String(describing: lineBeaconData?.lotKey))--\(lineBeaconData?.hwId ?? "")--\(String(describing: lineBeaconData?.vendorKey))")
            break
        
        default:
            print("SlotFrame---Unauthenticated Frame")
            break
        }
    }
    
    func writeFrame(peripheral : MTPeripheral) -> Void {
        let ib = MinewiBeacon.init()
        ib.slotNumber = 0;
        ib.uuid = "47410a54-99dd-49f9-a2f4-e1a7efe03c13";
        ib.major = 300;
        ib.minor = 30;
        ib.slotAdvInterval = 400;
        ib.slotAdvTxpower = -62;
        ib.slotRadioTxpower = -4;
        
        peripheral.connector.write(ib, completion: { (success, error) in
            if success {
                print("write success,%d",ib.slotRadioTxpower)
            }
            else {
                print(error as Any)
            }
        })
        
    }
    
    func setLineBeacon() -> Void {
   
        device?.connector.slotHandler.lineBeaconSetLotkey("0011223344556677", completion: { (success) in
            if success == true {
                print("Set LineBeacon's lotKey success")
            } else {
                print("Set LineBeacon's lotKey fail")
            }
        })
        
        device?.connector.slotHandler.lineBeaconSetHWID("0011223344", vendorKey: "00112233", completion: { (success) in
            if success == true {
                print("Set LineBeacon's hwid and vendorKey success")
            } else {
                print("Set LineBeacon's hwid and vendorKey fail")
            }
        })

    }
    
    func getTrigger() -> Void {
        let triggerData:MTTriggerData =  device?.connector.triggers[1] ?? MTTriggerData()
        
        print("TriggerData \n type:\(triggerData.type.rawValue)--advertisingSecond:\(String(describing: triggerData.value))--alwaysAdvertise:\( triggerData.always)--advInterval:\(triggerData.advInterval)--radioTxpower:\(triggerData.radioTxpower)")

    }
    
    func writeTrigger(peripheral : MTPeripheral) -> Void {
        // Tips:Use the correct initialization method for MTTriggerData
        let triggerData = MTTriggerData.init(slot: 1, paramSupport: true, triggerType: TriggerType.btnDtapLater, value: 30)
        triggerData?.always = false;
        triggerData?.advInterval = 100;
        triggerData?.radioTxpower = -20;
        
        peripheral.connector.writeTrigger(triggerData) { (success) in
            if success {
                print("write triggerData success")
            }
            else {
                print("write triggerData failed")
            }
        }
    }
}
