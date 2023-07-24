//
//  AccelerateView.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/6/26.
//

import SwiftUI
import Charts
import CoreBluetooth


@available(iOS 16.0, *)
struct AccelerateView: View {
    
    var peripheral: CBPeripheral!
    @StateObject var bluetoothViewModel: BluetoothViewModel
    
    var body: some View {
        VStack{
            controlView(peripheral: peripheral, bluetoothViewModel: bluetoothViewModel)
            Text("Accelerate")
                .fontWeight(.heavy)
                .font(.system(size: 20))
                .frame(width: 140, alignment: .center)
                .lineSpacing(24)
                .foregroundColor(Color.black)
            let Temperature = bluetoothViewModel.Temperature ?? "nil"
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
                if bluetoothViewModel.AccelerateData.count == 3{
//                    HStack{
//                        Text("\(bluetoothViewModel.AccelerateData[0].data[0].index.description)")
//                            .fontWeight(.heavy)
//                            .font(.system(size: 16))
//                        let time = bluetoothViewModel.AccelerateData[0].data[0].time.formatted(.dateTime.hour().minute().second().secondFraction(.fractional(3)))
//                        Text("\(time)")
//                            .fontWeight(.heavy)
//                            .font(.system(size: 16))
//                    }
                    
                    ScrollView(.horizontal) {
                        if bluetoothViewModel.AccelerateData[0].data.count < 30{
                            let widthC = 30*30
                            Chart1Hz(bluetoothViewModel: bluetoothViewModel, widthc: CGFloat(widthC))
                        }else{
                            let widthC = 30*CGFloat(bluetoothViewModel.AccelerateData[0].data.count+5)
                            Chart1Hz(bluetoothViewModel: bluetoothViewModel, widthc: widthC)
                        }
                        
                    }   // end ScrollView
                    .frame(width: 320, height: 420)
                }   // end if
                
            }
            .frame(width: 400, height: 420, alignment: .center)
        }   // End VStack
        
    }
    
}


struct Chart1Hz: View {
    @StateObject var bluetoothViewModel: BluetoothViewModel
    @State var widthc:CGFloat
    let curColor = Color(hue: 0.33, saturation: 0.81, brightness: 0.76)
    var body: some View {
        ZStack{
            Chart{
                ForEach(bluetoothViewModel.AccelerateData, id: \.axis) { series in
                    ForEach(Array(series.data.enumerated()), id: \.offset) { index, element in
                        let timeshow = element.time//.formatted(.dateTime.second().secondFraction(.fractional(3)))
                        LineMark(
                            x: .value("Time",timeshow),
                            y: .value("Data", element.data)
                        )
                        .foregroundStyle(by: .value("axis", series.axis))
                        //                    .symbol(by: .value("axis", series.axis))
                        //                    {
                        //                        Circle()
                        //                            .frame(width: 3)
                        ////                            .opacity(0.6)
                        //                    }
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
                AxisMarks(values: .automatic(desiredCount: 10)){ value in
//                AxisMarks{ value in
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
                Text("AccelerateData (m/s)")
            }
            .frame(width: widthc, height: 350)
            //        .chartPlotStyle { plotArea in
            //            plotArea
            //                .background(.blue.opacity(0.1))
            //        }
        }
    }
//    .onAppear {
//        
//    }
    
    
}

//                    .chartXScale(domain: bluetoothViewModel.AccelerateData[0].data[0].time-Double(2)...bluetoothViewModel.AccelerateData[0].data[0].time+Double(30))
//                    .chartXScale(range: .plotDimension( startPadding: bluetoothViewModel.AccelerateData[0].data[0].index-30, endPadding:bluetoothViewModel.AccelerateData[0].data[0].index+2), type: Int())
//                    .chartXScale(domain: bluetoothViewModel.AccelerateData[0].data[0].index-30...bluetoothViewModel.AccelerateData[0].data[0].index+3)    //2*Int(10e5)
//                    .chartXScale(domain: .automatic(dataType: Date.self) { _ in
//                        dates = bluetoothViewModel.AccelerateData[0].data[0].time
//                        range: .plotDimension(startPadding:, endPadding:)
//                    })


struct controlView: View{
    var peripheral: CBPeripheral!
    @StateObject var bluetoothViewModel: BluetoothViewModel
    
    var body: some View {
        HStack(spacing: 5){
            Button{
                //                        isConnect = bluetoothViewModel.isConnect(peripheral)
                let cmd : [UInt8] = [ 0x41, 0x58, 0x01, 0x00, 0x00, 0x00, 0x00, 0x5F ]
                bluetoothViewModel.SendCMD(peripheral, bluetoothViewModel.characteristicAcromaxBLE, cmd)
                bluetoothViewModel.getCurrentTime()
            }label: {
                HStack{
                    Image(systemName: "restart")
                        .foregroundColor(Color.blue)
                    Text("Start")
                }   // End HStack
                .fontWeight(.heavy)
                .font(.system(size: 16))
            }   // End button label
            Button{
                //                        isConnect = bluetoothViewModel.isConnect(peripheral)
                let cmd : [UInt8] = [ 0x41, 0x58, 0x02, 0x00, 0x00, 0x00, 0x00, 0xF9 ]
                bluetoothViewModel.SendCMD(peripheral, bluetoothViewModel.characteristicAcromaxBLE, cmd)
                
            }label: {
                HStack{
                    Image(systemName: "stop.circle")
                        .foregroundColor(Color.blue)
                    Text("Stop")
                }   // End HStack
                .fontWeight(.heavy)
                .font(.system(size: 16))
            }   // End button label
            Button{
                bluetoothViewModel.ResetDataArray()
                let cmd : [UInt8] = [ 0x41, 0x58, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3D ]
                bluetoothViewModel.SendCMD(peripheral, bluetoothViewModel.characteristicAcromaxBLE, cmd)
            }label: {
                HStack{
                    Image(systemName: "retarder.brakesignal")
                        .foregroundColor(Color.blue)
                    Text("Reset")
                }   // End HStack
                .fontWeight(.heavy)
                .font(.system(size: 16))
            }   // End button label
            
        }   // End HStack
        
        HStack(spacing: 5){
            
            Button{
                //                        isConnect = bluetoothViewModel.isConnect(peripheral)
                let cmd : [UInt8] = [ 0x41, 0x58, 0x03, 0x02, 0x00, 0x00, 0x00, 0xB7 ]
                bluetoothViewModel.SendCMD(peripheral, bluetoothViewModel.characteristicAcromaxBLE, cmd)
                bluetoothViewModel.getCurrentTime()
            }label: {
                HStack{
                    Text("1HZ")
                }   // End HStack
                .fontWeight(.heavy)
                .font(.system(size: 16))
            }   // End button label
            
            Button{
                //                        isConnect = bluetoothViewModel.isConnect(peripheral)
                let cmd : [UInt8] = [ 0x41, 0x58, 0x03, 0x01, 0x00, 0x00, 0x00, 0x8D ]
                bluetoothViewModel.SendCMD(peripheral, bluetoothViewModel.characteristicAcromaxBLE, cmd)
                bluetoothViewModel.getCurrentTime()
            }label: {
                HStack{
                    Text("10HZ")
                }   // End HStack
                .fontWeight(.heavy)
                .font(.system(size: 16))
            }   // End button label
            Button{
                //                        isConnect = bluetoothViewModel.isConnect(peripheral)
                let cmd : [UInt8] = [ 0x41, 0x58, 0x03, 0x00, 0x00, 0x00, 0x00, 0x9B ]
                bluetoothViewModel.SendCMD(peripheral, bluetoothViewModel.characteristicAcromaxBLE, cmd)
                bluetoothViewModel.getCurrentTime()
            }label: {
                HStack{
                    Text("100HZ")
                }   // End HStack
                .fontWeight(.heavy)
                .font(.system(size: 16))
            }   // End button label
            
        }   // End HStack
    }
}
