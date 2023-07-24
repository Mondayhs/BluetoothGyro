//
//  ViewController.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/6/7.
//

import UIKit
import CoreBluetooth


// MARK: - Core Bluetooth service IDs
let BLE_Service_CBUUID = CBUUID(string: "0x180D")


class BluetoothTableViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let fullScreenSize = UIScreen.main.bounds.size
    
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    private var peripheralNames:[String] = []
    
    
//    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("HIII")
        
        // 建立 UITableView 並設置原點及尺寸
        let tableView = UITableView(frame: CGRect(x: 0, y: 20, width: fullScreenSize.width, height: fullScreenSize.height - 20), style: .grouped)
        // 註冊 cell 的樣式及名稱
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // 設置委任對象
        tableView.delegate = self
        tableView.dataSource = self
        
        // 分隔線的樣式
        tableView.separatorStyle = .singleLine
        
        // 分隔線的間距 四個數值分別代表 上、左、下、右 的間距
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        
        // 是否可以點選 cell
        tableView.allowsSelection = true
        
        // 是否可以多選 cell
        tableView.allowsMultipleSelection = false
        
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Search Bluetooth"
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        tableView.delegate = self
        tableView.dataSource = self
        
//        self.view.addSubview(tableView)
        tableView.reloadData()
    }
    
    //MARK: - TableView
    // 每一組有幾個 cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ScannedDeviceCell")
        tableViewCell?.textLabel?.text = "\(peripheralNames[indexPath.section])"
        
        return tableViewCell!
    }
    
    // MARK: - connect bluetooh
    @objc func centralManagerDidUpdateState(_ central: CBCentralManager) {
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
        central.scanForPeripherals(withServices: nil)
        print("Scanning")
//        tableView.reloadData()
    }   // END func centralManagerDidUpdateState
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.name!)
        decodePeripheralState(peripheralState: peripheral.state)
        
        peripherals.append(peripheral)
        peripheralNames.append(peripheral.name ?? "unamed device")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
//        tableView.reloadData()
    }   // END func centralManager
    
    // 當找設備的服務時執行
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            
            for service in peripheral.services! {
                
                if service.uuid == BLE_Service_CBUUID {
                    
                    print("Service: \(service)")
                    
                    // STEP 9: look for characteristics of interest
                    // within services of interest
                    peripheral.discoverCharacteristics(nil, for: service)
                    
                }
                
            }
            
    } // END func peripheral(... didDiscoverServices
    
    // 當找設備的特徵時執行
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            //  當找設備的特徵時執行
            for characteristic in service.characteristics! {
                print(characteristic)
                
//                if characteristic.uuid == BLE_Body_Sensor_Location_Characteristic_CBUUID {
//
//                    // STEP 11: subscribe to a single notification
//                    // for characteristic of interest;
//                    // "When you call this method to read
//                    // the value of a characteristic, the peripheral
//                    // calls ... peripheral:didUpdateValueForCharacteristic:error:
//                    //
//                    // Read    Mandatory
//                    //
//                    peripheral.readValue(for: characteristic)
//
//                }
//
//                if characteristic.uuid == BLE_Heart_Rate_Measurement_Characteristic_CBUUID {
//
//                    // STEP 11: subscribe to regular notifications
//                    // for characteristic of interest;
//                    // "When you enable notifications for the
//                    // characteristic’s value, the peripheral calls
//                    // ... peripheral(_:didUpdateValueFor:error:)
//                    //
//                    // Notify    Mandatory
//                    //
//                    peripheral.setNotifyValue(true, for: characteristic)
//
//                }
                
            } // END for
            
        } // END func peripheral(... didDiscoverCharacteristicsFor service
    
    // 當找特徵有執行寫入
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
    } // END func peripheral(... didUpdateValueFor characteristic
    
    
    func decodePeripheralState(peripheralState: CBPeripheralState) {
            
            switch peripheralState  {
            case .disconnected:
                    print("Peripheral state: disconnected")
            case .connected:
                    print("Peripheral state: connected")
            case .connecting:
                    print("Peripheral state: connecting")
            case .disconnecting:
                    print("Peripheral state: disconnecting")
            default:
                print("ERROR!")
            }
//            tableView.reloadData()
    } // END func decodePeripheralState(peripheralState
    
}

//
//extension BluetoothTableViewController:CBCentralManagerDelegate, CBPeripheralDelegate{
//
//    // MARK: - connect bluetooh
//    @objc func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case   .poweredOn:
//            print("Bluetooth open")
//        case   .unauthorized:
//            print("unauthorized")
//        case   .poweredOff:
//            print("Bluetooth off")
//        default:
//            print("Unknow")
//        }
//        central.scanForPeripherals(withServices: nil)
//        print("Scanning")
////        tableView.reloadData()
//    }   // END func centralManagerDidUpdateState
//
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        print(peripheral.name!)
//        decodePeripheralState(peripheralState: peripheral.state)
//
//        peripherals.append(peripheral)
//        peripheralNames.append(peripheral.name ?? "unamed device")
//
//        peripheral.delegate = self
//        peripheral.discoverServices(nil)
////        tableView.reloadData()
//    }   // END func centralManager
//
//    // 當找設備的服務時執行
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//
//            for service in peripheral.services! {
//
//                if service.uuid == BLE_Service_CBUUID {
//
//                    print("Service: \(service)")
//
//                    // STEP 9: look for characteristics of interest
//                    // within services of interest
//                    peripheral.discoverCharacteristics(nil, for: service)
//
//                }
//
//            }
//
//    } // END func peripheral(... didDiscoverServices
//
//    // 當找設備的特徵時執行
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//            //  當找設備的特徵時執行
//            for characteristic in service.characteristics! {
//                print(characteristic)
//
////                if characteristic.uuid == BLE_Body_Sensor_Location_Characteristic_CBUUID {
////
////                    // STEP 11: subscribe to a single notification
////                    // for characteristic of interest;
////                    // "When you call this method to read
////                    // the value of a characteristic, the peripheral
////                    // calls ... peripheral:didUpdateValueForCharacteristic:error:
////                    //
////                    // Read    Mandatory
////                    //
////                    peripheral.readValue(for: characteristic)
////
////                }
////
////                if characteristic.uuid == BLE_Heart_Rate_Measurement_Characteristic_CBUUID {
////
////                    // STEP 11: subscribe to regular notifications
////                    // for characteristic of interest;
////                    // "When you enable notifications for the
////                    // characteristic’s value, the peripheral calls
////                    // ... peripheral(_:didUpdateValueFor:error:)
////                    //
////                    // Notify    Mandatory
////                    //
////                    peripheral.setNotifyValue(true, for: characteristic)
////
////                }
//
//            } // END for
//
//        } // END func peripheral(... didDiscoverCharacteristicsFor service
//
//    // 當找特徵有執行寫入
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//
//
//    } // END func peripheral(... didUpdateValueFor characteristic
//
//
//    func decodePeripheralState(peripheralState: CBPeripheralState) {
//
//            switch peripheralState  {
//            case .disconnected:
//                    print("Peripheral state: disconnected")
//            case .connected:
//                    print("Peripheral state: connected")
//            case .connecting:
//                    print("Peripheral state: connecting")
//            case .disconnecting:
//                    print("Peripheral state: disconnecting")
//            default:
//                print("ERROR!")
//            }
////            tableView.reloadData()
//    } // END func decodePeripheralState(peripheralState
//}
