////
////  BluetoothModel.swift
////  BLE_test
////
////  Created by zhou Chou on 2023/7/14.
////
//
//import SwiftUI
//import CoreBluetooth
//
//
//
//extension BluetoothViewModel{
//    
//    //Control Func
//    func startScan() {
//        let scanOption = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
//        self.centralManager.scanForPeripherals(withServices: nil)
//        print("# Start Scan")
//        isSearching = true
//    }
//    
//    func stopScan(){
//        disconnectPeripheral()
//        centralManager?.stopScan()
//        print("# Stop Scan")
//        isSearching = false
//    }
//    
//    func connectPeripheral(_ selectPeripheral: Peripheral?) {
//        guard let connectPeripheral = selectPeripheral else { return }
//        connectedPeripheral = selectPeripheral
//        centralManager.connect(connectPeripheral, options: nil)
//    }
//    func disconnectPeripheral() {
//        guard let connectedPeripheral = connectedPeripheral else { return }
//        centralManager?.cancelPeripheralConnection(self.peripheral!)
//    }
//}
