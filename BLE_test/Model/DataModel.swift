//
//  AccelerateModel.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/6/26.
//


import CoreBluetooth
import Charts
import UIKit

let DataSize = Int(150*30)

struct Value: Identifiable {
    var id = UUID()
    var index: Int
    var data: Float
    var time: Date
    init(_index: Int, _data: Float, _time: Date) {
        index = .init(_index)
        data = .init(_data)
        time = _time
    }
}
struct DataType: Identifiable {
    var id = UUID()
    var axis: String
    var data = [Value]()
    init(axis: String, data: [Value]) {
        self.axis = axis
        self.data = data
    }
}

extension BluetoothViewModel{
    
    func getCurrentTime(){
//        let formattedFractional = date.formatted(.dateTime.hour().minute().second().secondFraction(.fractional(3)))
        CurrentTime = Date.now
    }
    
    func dataWithHexString(hex: String) -> Data {
            var hex = hex
            var data = Data()
            while(hex.count > 0) {
                let subIndex = hex.index(hex.startIndex, offsetBy: 2)
                let c = String(hex[..<subIndex])
                hex = String(hex[subIndex...])
                var ch: UInt64 = 0
                Scanner(string: c).scanHexInt64(&ch)
                var char = UInt8(ch)
                data.append(&char, count: 1)
            }
            return data
    }
    
    func GetAllData(_ peripheral: CBPeripheral?,_ characteristic: CBCharacteristic?){
        guard let connectPeripheral = peripheral, let Characteristic = characteristic else {  return  }
        
        let tt = Data("abc".utf8)
        print("Data:--------",tt)
        connectPeripheral.writeValue(tt,for: Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func StorageData(_ characteristic: CBCharacteristic){
//        guard let characteristicValue = characteristic.value else { return }
        
    }
    
    func Analyze(_ characteristic: CBCharacteristic){
        guard let characteristicValue = characteristic.value?.hexEncodedString() else { return }
        var Sg: Float = 0.0
        var Sa: Float = 0.0
        var freq: Float = 0.0
        let head_end = characteristicValue.index(characteristicValue.startIndex, offsetBy: 4)
        let crc8_start = characteristicValue.index(characteristicValue.endIndex, offsetBy: -2)
        let head = characteristicValue[..<head_end]
        let crc8 = characteristicValue[crc8_start...]

        let Crc8Check = calcCRC8(String(characteristicValue.dropLast(2)))
        if head == "4158" && crc8.localizedCaseInsensitiveContains(Crc8Check){
//            let freq_start = characteristicValue.index(characteristicValue.startIndex, offsetBy: 31)
//            let freq_end = characteristicValue.index(characteristicValue.startIndex, offsetBy: 32)
            let Sgconfig_start = characteristicValue.index(characteristicValue.startIndex, offsetBy: 32)
            let Sgconfig_end = characteristicValue.index(characteristicValue.startIndex, offsetBy: 33)
            let Saconfig_start = characteristicValue.index(characteristicValue.startIndex, offsetBy: 33)
            let Saconfig_end = characteristicValue.index(characteristicValue.startIndex, offsetBy: 34)
            let freqence = characteristicValue[Sgconfig_start..<Sgconfig_end]
            let Saconfig = characteristicValue[Saconfig_start..<Saconfig_end]
            let Sgconfig = characteristicValue[Sgconfig_start..<Sgconfig_end]
            
            switch freqence{
            case "0", "1", "2", "3":
                freq = Float(10)
            case "4", "5", "6", "7":
                freq = Float(100)
            case "8", "9", "10", "11":
                freq = Float(1000)
            default:
                NSLog("No Data 'Frequence' Set")
            }
            
            switch Sgconfig{
            case "0", "4", "8":
                let sg = Float(131)
                Sg = sg
            case "1", "5", "9":
                let sg = Float(65.5)
                Sg = sg
            case "2", "6", "10":
                let sg = Float(32.8)
                Sg = sg
            case "3", "7", "11":
                let sg = Float(16.4)
                Sg = sg
            default:
                NSLog("No Data 'Sg' Set")
            }
            
            switch Saconfig{
            case "0":
                let sa = Float(16384)
                Sa = sa
            case "1":
                let sa = Float(8192)
                Sa = sa
            case "2":
                let sa = Float(4096)
                Sa = sa
            case "3":
                let sa = Float(2048)
                Sa = sa
            default:
                NSLog("No Data 'Sa' Set")
            }
            print("---head:", head, "-----Freq.:", freq, "-----Sa:", Sa, "-----Sg:", Sg, "----CRC8:", Crc8Check)
            let proccessValue = String(characteristicValue.dropFirst(4).dropLast(2))
            Proccess(proccessValue, Sa, Sg, Index, freq)
            
        }
    }
    
    func Proccess(_ aa:String?, _ Saconfig:Float?, _ Sgconfig:Float?, _ index:Int?, _ freq:Float?){
        guard let str = aa , let Sa = Saconfig , let Sg = Sgconfig, let index = index, let freq = freq else { return }
        let len = ((str.count)/4)-1
        var allData = [Float]()
        let tstart = str.index(str.startIndex, offsetBy: 30)
        let tend = str.index(str.startIndex, offsetBy: 34)
        let tvalue = UInt16(str[tstart..<tend], radix: 16) ?? 0
        let tindex = CurrentTime! + (Double(Float(tvalue)*freq)/1000)
        let formattedFractional = tindex.formatted(.dateTime.hour().minute().second().secondFraction(.fractional(3)))
        print("----xxx------- Now:","\(formattedFractional)","------xxx--------")
        for i in 0 ... len-1{
            let start = str.index(str.startIndex, offsetBy: i*4)
            let end = str.index(str.startIndex, offsetBy: 4*i+4)
            let value = Int16(bitPattern: UInt16(str[start..<end], radix: 16) ?? 0)
            print("Hex: 0x",String(str[start..<end]), "Value:",value)
            allData.append(Float(value))
        }
        
        print("Hex: 0x",String(str[tstart..<tend]), "Value:",tvalue)
//        print("~~~~ allData:",allData)
        
        let accXdata = Value(_index: index, _data: allData[0]/Sa, _time: tindex)
        let accYdata = Value(_index: index, _data: allData[1]/Sa, _time: tindex)
        let accZdata = Value(_index: index, _data: allData[2]/Sa, _time: tindex)
        let gyoXdata = Value(_index: index, _data: allData[3]/Sg, _time: tindex)
        let gyoYdata = Value(_index: index, _data: allData[4]/Sg, _time: tindex)
        let gyoZdata = Value(_index: index, _data: allData[5]/Sg, _time: tindex)
        print("-------index:", index)
        
        //    MakeData
        MakeAccelerateData(accXdata, accYdata, accZdata, index)
        MakeGyroData(gyoXdata, gyoYdata, gyoZdata, index)
        MakeTemperature(allData[6], index)
        Index = index+1
    }
    
    func MakeAccelerateData(_ x: Value?, _ y: Value?, _ z: Value?, _ index:Int?){
        guard let X = x , let Y = y , let Z = z , let index = index else { return }
        if index == 1{
            let AccX = DataType(axis:"X", data: [X])
            let AccY = DataType(axis:"Y", data: [Y])
            let AccZ = DataType(axis:"Z", data: [Z])
            AccelerateData.append(AccX)
            AccelerateData.append(AccY)
            AccelerateData.append(AccZ)
        }else{

            AccelerateData[0].data.append(X)
            AccelerateData[1].data.append(Y)
            AccelerateData[2].data.append(Z)
        }
        if AccelerateData[0].data.count > 300{
//            print(AccelerateData[0].data)
            AccelerateData[0].data.removeFirst()
            AccelerateData[1].data.removeFirst()
            AccelerateData[2].data.removeFirst()
            
        }
    }
    
    func MakeGyroData(_ x: Value?, _ y: Value?, _ z: Value?, _ index:Int?){
        guard let X = x , let Y = y , let Z = z , let index = index else { return }
        if index == 1{
            let gyroX = DataType(axis:"X", data: [X])
            let gyroY = DataType(axis:"Y", data: [Y])
            let gyroZ = DataType(axis:"Z", data: [Z])
            GyroData.append(gyroX)
            GyroData.append(gyroY)
            GyroData.append(gyroZ)
        }else{

            GyroData[0].data.append(X)
            GyroData[1].data.append(Y)
            GyroData[2].data.append(Z)
        }
        if GyroData[0].data.count > 300{
//            print(AccelerateData[0].data)
            GyroData[0].data.remove(at: 0)
            GyroData[1].data.remove(at: 0)
            GyroData[2].data.remove(at: 0)
            
        }
    }
    
    func MakeTemperature(_ tmp: Float?, _ index:Int?) {
        guard let temperature = tmp , let index = index else { return  }
        if index == 1 || index%50 == 0{
            let Tmp = String(format: "%.2f", temperature/340.0+36.53)
            //        print(Tmp)
            Temperature = Tmp
        }
    }
    
    func ResetDataArray(){
        AccelerateData = []
        GyroData = []
        Index = 1
    }
}

