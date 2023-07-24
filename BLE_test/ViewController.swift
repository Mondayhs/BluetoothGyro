//
//  ViewController.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/6/7.
//

import UIKit
import CoreBluetooth


//class BluetoothViewModel: NSObject, ObservableObject, CBCentralManagerDelegate {
//

//
//    private var centralManager: CBCentralManager?
//    private var peripherals: [CBPeripheral] = []
//    @Published var peripheralNames: [String] = []
//
//    override init() {
//        super.init()
//        self.centralManager = CBCentralManager(delegate: self, queue: .main)
//    }
//}

// MARK: - Core Bluetooth service IDs
let BLE_Service_CBUUID = CBUUID(string: "0x180D")


class BluetoothContentView: UIViewController ,UITableViewDelegate , UITableViewDataSource ,  CBCentralManagerDelegate, CBPeripheralDelegate{
    
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripheralNames:[String] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        print("HIII")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Search Bluetooth"
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
//        self.view.addSubview(tableView)
        tableView.reloadData()
    }
    
    //MARK: - TableView
    // 每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
    }   // END func centralManagerDidUpdateState
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.name!)
        decodePeripheralState(peripheralState: peripheral.state)
        
        peripherals.append(peripheral)
        peripheralNames.append(peripheral.name ?? "unamed device")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
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
            
    } // END func decodePeripheralState(peripheralState
}
