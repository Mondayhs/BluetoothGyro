//
//  GyroView.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/7/3.
//

import SwiftUI
import Charts
import CoreBluetooth

struct GyroView: View {
    var peripheral: CBPeripheral!
//    @EnvironmentObject var bluetoothViewModel: BluetoothViewModel
    @StateObject var bluetoothViewModel: BluetoothViewModel
    
    var body: some View {
        VStack{
            controlView(peripheral: peripheral, bluetoothViewModel: bluetoothViewModel)
            let Temperature = bluetoothViewModel.Temperature ?? "worng"
            Text("Angular Accelerate")
                .fontWeight(.heavy)
                .font(.system(size: 20))
//                .frame(width: 150, alignment: .center)
//                .lineSpacing(24)
                .foregroundColor(Color.black)
            HStack(spacing: 20){
                Text("Temperature: \(Temperature)")
                    .fontWeight(.heavy)
                    .font(.system(size: 13))
//                if bluetoothViewModel.isConnect(peripheral){
//                    Text("Connect")
//                        .fontWeight(.heavy)
//                        .font(.system(size: 13))
//                        .frame(width: 140, alignment: .leading)
//                        .lineSpacing(24)
//                        .foregroundColor(Color.green)
//                }else {
//                    Text("Disconnect")
//                        .fontWeight(.heavy)
//                        .font(.system(size: 13))
//                        .frame(width: 140, alignment: .leading)
//                        .lineSpacing(24)
//                        .foregroundColor(Color.gray)
//                }
            }   //End HStack
                
            VStack{
                if bluetoothViewModel.GyroData.count == 3{
                    ScrollView(.horizontal) {
                        if bluetoothViewModel.GyroData[0].data.count < 30{
                            let widthC = 30*30
                            Chart_G(bluetoothViewModel: bluetoothViewModel, widthc: CGFloat(widthC))
                        }else{
                            let widthC = 30*CGFloat(bluetoothViewModel.GyroData[0].data.count+5)
                            Chart_G(bluetoothViewModel: bluetoothViewModel, widthc: widthC)
                        }
                        
                    }   // end ScrollView
                    .frame(width: 350, height: 420)
                }   //End if
            }   //End VStack
        }
    }
}

struct Chart_G: View {
    @StateObject var bluetoothViewModel: BluetoothViewModel
    @State var widthc:CGFloat
    let curColor = Color(hue: 0.33, saturation: 0.81, brightness: 0.76)
    var body: some View {
        ZStack{
            Chart{
                ForEach(bluetoothViewModel.GyroData, id: \.axis) { series in
                    ForEach(Array(series.data.enumerated()), id: \.offset) { index, element in
                        let timeshow = element.time
                        LineMark(
                            x: .value("Time",timeshow),
                            y: .value("Data", element.data)
                        )
                        .foregroundStyle(by: .value("axis", series.axis))
                        .accessibilityLabel("\(timeshow.formatted(.dateTime.hour().minute().second().secondFraction(.fractional(3))))")
                        .accessibilityValue("\(element.data) m/s")
                    }
                }
            }   // End Chart
            .chartLegend(position: .overlay, alignment: .top)
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 6))
            }
            .chartXAxis(content: {
                AxisMarks{ value in
                    AxisValueLabel (anchor: UnitPoint(x: 0.5, y: 35)){//}, collisionResolution: .greedy){
                        if let time = value.as(Date.self) {
                            let ttime = time.formatted(.dateTime.hour().minute().second().secondFraction(.fractional(3)))
                            Text(ttime)
                                .rotationEffect(Angle(degrees: 90))
                        }
                    }
                }
            })
            .chartXAxisLabel(position: .bottom, alignment: .center) {
                Text("Time (hr:min:s:ms)")
            }
            .chartXAxisLabel(position: .leading, alignment: .center) {
                Text("Angular Velocity (deg/s)")
            }
            .frame(width: widthc, height: 350)
        }
    }
}
