//
//  Gyro3DView.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/7/5.
//

import SwiftUI
import SceneKit
import Model3DView
import CoreBluetooth

struct Gyro3DView: View {
    var peripheral: CBPeripheral!
    @StateObject var bluetoothViewModel: BluetoothViewModel
    @State private var degreeX: Double = 0
    @State private var degreeY: Double = 0
    @State private var degreeZ: Double = 0
    
    var body: some View {
        VStack{
            ZStack {
                ZStack {
                    Text("Y")
                        .offset(.init(width: 165, height: 0))
                    Rectangle()
                        .stroke(Color.blue, lineWidth: 5)
                        .opacity(0.2)
                        .frame(width: 300, height: 1, alignment: .center)
                }
                HStack {
                    Text("X")
                      .offset(.init(width: -100, height: 75))
                    Rectangle()
                      .stroke(Color.red, lineWidth: 5)
                      .opacity(0.2)
                      .frame(width: 1, height: 800, alignment: .center)
                      .rotation3DEffect(.degrees(80), axis: (x: 0, y: 0, z: 1), anchor: .center, perspective: -0.1)
                      .rotation3DEffect(.degrees(-75), axis: (x: 0, y: 1, z: 0), anchor: .center, perspective: -0.1)
                    
                }
                .offset(.init(width: -8, height: 0))
                ZStack {
                    Text("Z")
                        .offset(.init(width: 2, height: -165))
                    Rectangle()
                        .stroke(Color.green, lineWidth: 5)
                        .opacity(0.2)
                        .frame(width: 1, height: 300, alignment: .center)
                }
                if bluetoothViewModel.GyroData.count == 3{
                    let X = Double(bluetoothViewModel.GyroData[0].data.last?.data ?? 0)
                    let Y = Double(bluetoothViewModel.GyroData[1].data.last?.data ?? 0)
                    let Z = Double(bluetoothViewModel.GyroData[2].data.last?.data ?? 0)
                    
                    Model3DView(named: "toy_biplane_idle.usdz")
                        .transform(scale: 0.2)
                        .offset(.init(width: 0, height: -90))
                        .rotation3DEffect(.degrees(-25), axis: (x: 0, y: 1, z: 0), anchor: .center, perspective: -0.1)
                        .rotation3DEffect(.degrees(X), axis: (x: 1, y: 0, z: 0))
                        .rotation3DEffect(.degrees(Y), axis: (x: 0, y: 1, z: 0))
                        .rotation3DEffect(.degrees(Z), axis: (x: 0, y: 0, z: 1))
                }
            }   // End ZStack
            
            .frame(width: 120, height: 120, alignment: .center)
            
//            VStack{
//                Text("")
//            }   // End VStack
            
            
        }   // End VStack
        .frame(width: 220, height: 420, alignment: .center)
    }
}


struct AccDirectView: View {
    @StateObject var bluetoothViewModel: BluetoothViewModel
    var body: some View {
        ZStack {
            ZStack {
                Text("X")
                    .offset(.init(width: 180, height: 0))
                Rectangle()
                    .stroke(Color.blue, lineWidth: 5)
                    .opacity(0.2)
                    .frame(width: 200, height: 1, alignment: .center)
            }
            ZStack {
                Text("Y")
                    .offset(.init(width: 2, height: -100))
                Rectangle()
                    .stroke(Color.green, lineWidth: 5)
                    .opacity(0.2)
                    .frame(width: 1, height: 200, alignment: .center)
            }
            if bluetoothViewModel.AccelerateData.count == 3{
                let X = Double(bluetoothViewModel.AccelerateData[0].data[29].data)
                let Y = Double(bluetoothViewModel.AccelerateData[1].data[29].data)
//                    let Z = Double(bluetoothViewModel.AccelerateData[2].data[29].data)
//                    let deg = tan(Y/X)
                ZStack {
                    Path() { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: X*10, y: Y*10))
                    }
                    .stroke(Color.black, lineWidth: 5)
//                        .opacity(0.2)
                }
//                    .rotation3DEffect(.degrees(deg), axis: (x: 0, y: 0, z: 1))
            }
            
        }   // End ZStack
    }
    
}
