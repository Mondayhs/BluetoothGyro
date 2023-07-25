//
//  SwiftUIView.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/6/19.
//

import SwiftUI
import CoreBluetooth

@available(iOS 16.0, *)
struct ContentView: View{
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    
//    @State private var TransmitData = ""
    @FocusState private var nameIsFocused: Bool
    @State private var isConnect = false
    @State private var date = Date.now.formatted(.dateTime.hour().minute().second())
    @State private var phAlert = false
    @State private var witchView = 0
    
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    
    let timer = Timer.publish(
            every: 1, // second
            on: .main,
            in: .common
        ).autoconnect()
    
    var body: some View {
            VStack (spacing: 10){
                VStack{
                    HStack(spacing: 6) {
                        Ellipse()
                            .fill(Color(red: 1, green: 0.74, blue: 0.07))
                            .frame(width: 24, height: 24)
                            .overlay(Ellipse().stroke(Color(red: 0.09, green: 0.10, blue: 0.12), lineWidth: 2))
                            .frame(width: 24, height: 24)
                         if let BLEperipheral = peripheral.name {
                            Text("\(BLEperipheral)")
                                 .fontWeight(.heavy)
                                 .font(.body)
                                 .frame(width: 219, alignment: .leading)
                                 .lineSpacing(24)
                        } else {
                            Text("peripheral is nil")
                                .fontWeight(.heavy)
                                .font(.body)
                                .frame(width: 219, alignment: .leading)
                                .lineSpacing(24)
                        }   // End If else
                        
                    }   // End HStack
                    .frame(width: 300, height: 30)
                    .background(Color.white)
                    HStack(){
                        HStack(spacing: 6) {
                            if isConnect{
                                Ellipse()
                                    .fill(Color(hue: 0.236, saturation: 0.93, brightness: 1.0))
                                    .frame(width: 20, height: 20)
                                    .overlay(Ellipse().stroke(Color(red: 0.09, green: 0.10, blue: 0.12), lineWidth: 2))
                                    .frame(width: 20, height: 20)
                                
                                Text("Connect")
                                        .fontWeight(.heavy)
                                        .font(.body)
                                        .frame(width: 140, alignment: .leading)
                                        .lineSpacing(24)
                                        .foregroundColor(Color(hue: 0.453, saturation: 0.732, brightness: 0.762))
                            }else {
                                Ellipse()
                                    .fill(Color.gray)
                                    .frame(width: 20, height: 20)
                                    .overlay(Ellipse().stroke(Color(red: 0.09, green: 0.10, blue: 0.12), lineWidth: 2))
                                    .frame(width: 20, height: 20)
                                Text("Disconnect")
                                    .fontWeight(.heavy)
                                    .font(.body)
                                    .frame(width: 140, alignment: .leading)
                                    .lineSpacing(24)
                                    .foregroundColor(Color.gray)
                            }
                        }   // End HStack
                            Button{
                                bluetoothViewModel.ConnectToph(centralManager, peripheral)
                                isConnect = bluetoothViewModel.isConnect(peripheral)
                                print("State:", bluetoothViewModel.isConnect(peripheral))
                            }label: {
                                Text("Connect")
                                    .fontWeight(.heavy)
                                    .font(.system(size: 10))
                                    .frame(width: 50, height: 30)
                                    .background(Color(red: 1, green: 0.74, blue: 0.07))
                                    .cornerRadius(12)
                                    .shadow(radius: 2, y: 1)
                            }   // End button label
                    }// End HStack
                    .frame(width: 300, height: 30)
                    .background(Color.white)
                }
                .frame(width: 300, height: 120)
                .cornerRadius(12)
                .overlay(BorderStyle)
//                HStack {
//
//                    Button{
//                        bluetoothViewModel.TrigPeripheral(peripheral)
//                        isConnect = bluetoothViewModel.isConnect(peripheral)
//                        print("State:", bluetoothViewModel.isConnect(peripheral))
//
//                    }label: {
//                        HStack(spacing: 6) {
//                            Image(systemName: "magnifyingglass")
//                            Text("Find Characteristic")
//                                .fontWeight(.heavy)
//                                .font(.system(size: 18))
//                                .lineSpacing(28)
//                        }
//                        .padding(15)
//                        .frame(width: 230, height: 60)
//                        .background(Color(red: 1, green: 0.74, blue: 0.07))
//                        .cornerRadius(12)
//                        .overlay(BorderStyle)
//                        //                        .padding()
//                        .shadow(radius: 3, y: 3)
//
//                    }   // End button label
//                }   // End HStack
//                .alert(isPresented: $isConnect){
//                    Alert(title: Text("\(String(describing: peripheral.name!)) Disconnected"),
//                          message:Text("Please press 'connect' button"))
//                }// End alert
//                HStack(spacing: 15) {
//                    TextField("Input command", text: $TransmitData, prompt: Text("Input command"))
//                        .frame(width: 70, height: 30)
//                        .fontWeight(.medium)
//                        .font(.system(size: 16))
//                        .padding()
//                        .overlay(BorderStyle)
//                        .keyboardType(.numberPad)
//                        .focused($nameIsFocused)
//
//
//                    Button{
////                        isConnect = bluetoothViewModel.isConnect(peripheral)
//                        nameIsFocused = false
//                        bluetoothViewModel.SendCMD(peripheral, bluetoothViewModel.characteristicAcromaxBLE, TransmitData)
////                        bluetoothViewModel.SendCMD(peripheral, bluetoothViewModel.characteristicTest, TransmitData)
//                        print(TransmitData)
//
//                    }label: {
//                        HStack{
//                            Image(systemName: "paperplane.circle")
//                                .foregroundColor(Color.white)
//                            Text("Confirm")
//                        }   // End HStack
//                        .fontWeight(.heavy)
//                        .font(.system(size: 16))
//                        .frame(width: 120, height: 60)
//                        .background(Color(red: 1, green: 0.74, blue: 0.07))
//                        .cornerRadius(12)
//                        .overlay(BorderStyle)
//                        .shadow(radius: 2, y: 1)
//                    }   // End button label
//                    if bluetoothViewModel.isTransmit{
//                        Image(systemName: "arrow.right.arrow.left.circle.fill")
//                            .foregroundColor(Color.pink)
//                    }
//
//                }   // End HStack
                
                
                
                HStack{
                    Button{
                        bluetoothViewModel.TrigPeripheral(peripheral)
                        witchView = 1
                    }label: {
                        Text("Accelerate")
                            .fontWeight(.heavy)
                            .font(.system(size: 10))
                            .frame(width: 90, height: 40)
                            .background(Color(red: 1, green: 0.74, blue: 0.07))
                            .cornerRadius(12)
                            .overlay(BorderStyle)
                            .shadow(radius: 2, y: 1)
                    }   // End button label
                    Button{
                        bluetoothViewModel.TrigPeripheral(peripheral)
                        witchView = 2
                    }label: {
                        Text("Angular Accelerate")
                            .fontWeight(.heavy)
                            .font(.system(size: 10))
                            .frame(width: 90, height: 40)
                            .background(Color(red: 1, green: 0.74, blue: 0.07))
                            .cornerRadius(12)
                            .overlay(BorderStyle)
                            .shadow(radius: 2, y: 1)
                    }   // End button label
                    Button{
                        bluetoothViewModel.TrigPeripheral(peripheral)
                        witchView = 3
                    }label: {
                        Text("Gyro3DView")
                            .fontWeight(.heavy)
                            .font(.system(size: 10))
                            .frame(width: 90, height: 40)
                            .background(Color(red: 1, green: 0.74, blue: 0.07))
                            .cornerRadius(12)
                            .overlay(BorderStyle)
                            .shadow(radius: 2, y: 1)
                    }   // End button label
                }
                VStack{
                    SelectView(witchView: $witchView, peripheral: peripheral, bluetoothViewModel: bluetoothViewModel)
                }
                .alert(Text("Disconnected"), isPresented: $phAlert){
                    Button("OK") {
                        bluetoothViewModel.ConnectToph(centralManager, peripheral)}
                }message: { Text("The peripheral \(String(describing: peripheral.name!)) has been disconnected")}
//                .alert(isPresented: $phAlert){
//                    Alert(title: Text("Disconnected"),
//                          message:Text("The peripheral \(String(describing: peripheral.name!)) has been disconnected"))
//
//                }// End alert
                .onReceive(timer) { (_) in
                    isConnect = bluetoothViewModel.isConnect(peripheral)
                    if (isConnect != true){
                        phAlert = true
                    }
                    
                    date = Date.now.formatted(.dateTime.hour().minute().second())
                }
            }   // End VStack
            
    }   //  End Body
    
   
    var BorderStyle: some View {
            RoundedRectangle(cornerRadius: 12)
            .stroke(Color(red: 0.086, green: 0.10, blue: 0.12), lineWidth: 4)
            
    }   //  End BorderStyle
    
}

struct SwiftUIView_Previews: PreviewProvider {
    @available(iOS 16.0, *)
    static var previews: some View {
        ContentView()
    }
}



struct SelectView: View{
    @Binding var witchView: Int
    var peripheral: CBPeripheral!
    @StateObject var bluetoothViewModel: BluetoothViewModel
    
    var body: some View {
        VStack{
            switch witchView{
            case 0:
                if (peripheral.name == "Acromax_BLE") {
                    Text("Hi, There have three type page to show gyro. ")
                }
                else{
                    Text("Just Show")
                }
            case 1:
                AccelerateView(peripheral: peripheral, bluetoothViewModel: bluetoothViewModel)
            case 2:
                GyroView(peripheral: peripheral, bluetoothViewModel: bluetoothViewModel)
            case 3:
                Gyro3DView(peripheral: peripheral, bluetoothViewModel: bluetoothViewModel)
            case 4:
                For_test()
            default:
                Text("GOo")
            }
        }
    }
}
