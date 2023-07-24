////
////  BleSearchTableView.swift
////  BLE_test
////
////  Created by zhou Chou on 2023/7/12.
////
//
//import SwiftUI
//import CoreBluetooth
//
//struct BleSearchTableView: View {
//    
//    var peripheral: CBPeripheral!
//    @StateObject var bluetoothViewModel: BluetoothViewModel
//    
//    var body: some View {
//        ZStack{
//            
//        }
//    }
//}
//
//
//struct PeripheralCells: View {
//    @StateObject var bluetoothViewModel: BluetoothViewModel
//    
//    var body: some View {
//        ForEach(0..<bleManager.foundPeripherals.count, id: \.self) { num in
//            Button(action: {
//                bleManager.connectPeripheral(bleManager.foundPeripherals[num])
//            }) {
//                HStack {
//                    Text("\(bleManager.foundPeripherals[num].name)")
//                    Spacer()
//                    Text("\(bleManager.foundPeripherals[num].rssi) dBm")
//                }
//            }
//        }
//    }
//}
