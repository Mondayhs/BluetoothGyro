//
//  BLEmodel.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/6/20.
//

import UIKit
import CoreBluetooth

let Acromax_BLE_CBUUID = CBUUID(string: "0xFFE1")

public var Index: Int = 1

class BluetoothViewModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
//    @Published var isSearching: Bool = false
//    @Published var foundPeripheral: [Peripheral] = []
    
    
    
    @Published var isTransmit: Bool = false
//    @Published var readValue: String?
    @Published var connectedPeripheral: CBPeripheral!
    @Published var characteristicAcromaxBLE: CBCharacteristic?
    @Published var AccelerateData : [DataType] = []
    @Published var GyroData : [DataType] = []
    @Published var Temperature: String?
    
    @Published var CurrentTime: Date?
    @Published var crcdd: String?
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var characteristic: CBCharacteristic?
    
    var showDisconnectionWarning: Bool = true
    
    override init() {
        super.init()
        guard let peripheral = PublicPeripheral else{return}
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("model:", centralManager as Any)
        print("model-ph:", peripheral as Any)
//        AccelerateData = [("X",)]
//        isConnected = true
        
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
    // MARK: - connect bluetooh
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        guard let centralManager = central else { print("error49"); return }
        print("Connect success!!!")
        // discover all service
        peripheral.discoverServices(nil)
        peripheral.delegate = self
//        if self.peripheral != nil {
//            if self.peripheral!.state == .connected || self.peripheral!.state == .connecting {
//                self.peripheral!.delegate = self
//                self.peripheral!.discoverServices(nil)
//            }else {print("peripheral not to connect")}
//        }else {print("peripheral is nil")}

    } // END func centralManager didConnect
//
    func centralManager(_ central: CBCentralManager, didDisconnectperipheral: CBPeripheral) {
        print("--------!!!Disconnect!!!------")
        

    } // END func centralManager didDisConnect
    
    // MARK: - peripheral find services
    // 當找設備的服務時執行
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("--------------do DiscoverCharacteristics--------------")
        if(error != nil){
            print("Find services\(String(describing: peripheral.name)) is error!  Error:")
            print("Error: \(String(describing: error?.localizedDescription))")
        }
        for service in peripheral.services! {
            
            peripheral.discoverCharacteristics(nil, for: service)
            //                print("Service: \(service)")
        }
            
    } // END func peripheral(... didDiscoverServices
    
    //  當找設備的特徵時執行
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        print("-------------------do didDiscoverCharacteristics----------------")
        if(error != nil){
            print("Find Characteristics\(String(describing: peripheral.name)) is error!  Error:")
            print("Error: \(String(describing: error?.localizedDescription))")
        }
        
        for characteristic in service.characteristics! {
            if characteristic.uuid == Acromax_BLE_CBUUID{
                characteristicAcromaxBLE = characteristic
                print("characteristic:--------", characteristicAcromaxBLE as Any)
            }
            
            peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(true, for: characteristic)    // 訂閱
        }
        self.characteristic = service.characteristics?.last
    }
    /** 訂閱狀態 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
            if let error = error {
                print("訂閱失敗: \(error)")
                return
            }
            if characteristic.isNotifying {
                print("訂閱成功")
            } else {
                print("取消訂閱")
            }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        let result = NSString(data: characteristic.value ??  Data(base64Encoded: "")!, encoding: String.Encoding.utf8.rawValue)
//        print("----------result:",result as Any)
//        let currentDate = Date()
        let date = Date.now
        let formattedFractional = date.formatted(.dateTime.hour().minute().second().secondFraction(.fractional(3)))
        print("--------------- Now:","\(formattedFractional)","------------------")
        print("characteristic uuid:\(characteristic.uuid.uuidString) properties:\(propertiesString(properties: characteristic.properties) ?? " ") value: \( String(describing: characteristic.value?.hexEncodedString())) \(String(describing: characteristic.value))")
       
        if characteristic.uuid == Acromax_BLE_CBUUID && characteristic.value?.hexEncodedString().count ?? 0 == 40{
            
//            print("------------------HERE-----------------")
            Analyze(characteristic)
        }
    } // END func peripheral(... didUpdateValueFor characteristic
    
    /** 寫入數據 */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("error \(error)")
            return
        }
        print("寫入數據")
        isTransmit = true
    }
    
    // MARK: - Other function
    func isConnect(_ peripheral: CBPeripheral?) -> Bool {
        guard let PeripheralState = peripheral?.state else {
            print("Error!!! (in BLE isConenct) ")
            return false
        }
        if PeripheralState == .connected{
            return true
        }
        return false
    }
    
    func ConnectToph(_ central: CBCentralManager?, _ peripheral: CBPeripheral?){
        guard let centralManager = central, let connectPeripheral = peripheral else { print("error ConnectToph"); return }
        centralManager.connect(connectPeripheral, options: nil)
        if connectPeripheral.state == .connected {
            connectPeripheral.delegate = self
            connectPeripheral.discoverServices(nil)
        }else {
            if centralManager.state != .poweredOn{
                print("Bluetooth doesn't open!")
            }
            print("peripheral not to connect")
            
        }
        print("BLEmodel:",connectPeripheral)
    }
    
    func TrigPeripheral(_ peripheral: CBPeripheral?) {
        guard let connectPeripheral = peripheral else { print("error TrigPeripheral"); return }
//        self.peripheral = connectPeripheral
//        if self.peripheral != nil {
        if connectPeripheral.state == .connected {
            connectPeripheral.delegate = self
            connectPeripheral.discoverServices(nil)
        }else {print("peripheral not to connect")}
//        }else {print("peripheral is nil")}
    }
    
    func SendCMD(_ peripheral: CBPeripheral?,_ characteristic: CBCharacteristic?, _ sender: [UInt8]?) {
        guard let connectPeripheral = peripheral, let Characteristic = characteristic, let bytes = sender else {print("Error!!! (in BLE SendCMD) "); return}
        isTransmit = false
        
        let dataTx = Data(bytes)
//        let dataT = dataWithHexString(hex: "1111")
        print("Data1:--------",dataTx.hexEncodedString())
        connectPeripheral.writeValue(dataTx ,for: Characteristic, type: .withoutResponse)
//        connectPeripheral.writeValue(dataTx ,for: Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    
    func propertiesString(properties: CBCharacteristicProperties)->(String)!{
        var propertiesReturn : String = ""
        if (properties.rawValue & CBCharacteristicProperties.broadcast.rawValue) != 0 {
                propertiesReturn += "broadcast|"
        }
        if (properties.rawValue & CBCharacteristicProperties.read.rawValue) != 0 {
                propertiesReturn += "read|"
        }
        if (properties.rawValue & CBCharacteristicProperties.writeWithoutResponse.rawValue) != 0 {
                propertiesReturn += "write without response|"
        }
        if (properties.rawValue & CBCharacteristicProperties.write.rawValue) != 0 {
                propertiesReturn += "write|"
        }
        if (properties.rawValue & CBCharacteristicProperties.notify.rawValue) != 0 {
                propertiesReturn += "notify!"
        }
        if (properties.rawValue & CBCharacteristicProperties.indicate.rawValue) != 0 {
                propertiesReturn += "indicate|"
        }
        if (properties.rawValue & CBCharacteristicProperties.authenticatedSignedWrites.rawValue) != 0 {
                propertiesReturn += "authenticated signed writes|"
        }
        if (properties.rawValue & CBCharacteristicProperties.extendedProperties.rawValue) != 0 {
                propertiesReturn += "indicate "
        }
        if (properties.rawValue & CBCharacteristicProperties.notifyEncryptionRequired.rawValue) != 0 {
                propertiesReturn += "notify encryption required|"
        }
        if (properties.rawValue & CBCharacteristicProperties.indicateEncryptionRequired.rawValue) != 0 {
                propertiesReturn += "indicate encryption required "
        }
        return propertiesReturn
    }
    

}




extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8 (bytes, radix: 16) {
                data.append (&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}
