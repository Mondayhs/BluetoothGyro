//
//  DeviceViewController.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/6/13.
//

import UIKit
import CoreBluetooth
import SwiftUI

public var PublicPeripheral: CBPeripheral?
class DeviceViewController: UIViewController, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
//    let BLE_Device_Service_CBUUID = CBUUID(string: "0x180D")
    
    var peripheral: CBPeripheral?
    var centralManager: CBCentralManager!
    var peripheralName: String?
//    public var TransmitData: String?
    
//    private var Deviceservices: [CBService] = []
    
//    @IBOutlet weak var TransmitLabel: UILabel!
//    @IBOutlet weak var TransmitTextField: UITextField!
//    @IBOutlet weak var TransmitButton: UIButton!
//    @IBOutlet weak var FindButton: UIButton!
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // 重新设置delegate
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global())
        PublicPeripheral = self.peripheral
        print("DE-ph:", self.peripheral as Any)
        print("DE-PublicPeripheral:", self.peripheral as Any)
//        self.TransmitLabel.leftAlignWith(title:"Input Transmit Command: ")
//        self.TransmitButton.configureWith(title:"確認", selector:#selector(TransmitButtonPressed), target:self)
//        self.FindButton.configureWith(title:"Find", selector:#selector(FindButtonPressed), target:self)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    // MARK: - UIHostingController
    @IBSegueAction func SwiftUIshow(_ coder: NSCoder) -> UIViewController? {
        
        return UIHostingController(coder: coder, rootView: ContentView(centralManager:centralManager, peripheral:peripheral))
    }
    

    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case   .poweredOn:
            print("Bluetooth open")
        case   .unauthorized:
            print("unauthorized")
        case   .poweredOff:
            print("Bluetooth off")
        default:
            print("Unknow")
        }
    }
    
    

    

}
