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
//struct TView: View {
//    
//    let colors: [Color] = [ .yellow, .blue, .green, .indigo, .brown ]
//    let tabbarItems = [ "Random", "Travel", "Wallpaper", "Food", "Interior Design" ]
//    
//    var peripheral: CBPeripheral!
//    @StateObject var bluetoothViewModel: BluetoothViewModel
//    
//    @State private var selectedIndex = 0
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            TabView(selection: $selectedIndex) {
//                AccelerateView(peripheral: peripheral, bluetoothViewModel: bluetoothViewModel)
//                    .tag(0)
//
//                For_test()
//                    .tag(1)
////
////                ChatView()
////                    .tag(2)
////
////                ProfileView()
////                    .tag(3)
//            }
//            .ignoresSafeArea()
//
//            BleSearchTablebarView(tabbarItems: tabbarItems, selectedIndex: selectedIndex)
//                .padding(.horizontal)
//        }
//    }
//}
//
//struct BleSearchTablebarView: View {
//    var tabbarItems: [String]
//    @State var selectedIndex = 0
//    
//    @Namespace private var menuItemTransition
//    
//
//    var body: some View {
//        ScrollViewReader { scrollView in
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    ForEach(tabbarItems.indices, id: \.self) { index in
//
//                        TabbarItem(name: tabbarItems[index], isActive: selectedIndex == index, namespace: menuItemTransition)
//                            .onTapGesture {
//                                withAnimation(.easeInOut) {
//                                    selectedIndex = index
//                                }
//                            }
//                    }
//                }
//            }
//            .padding()
//            .background(Color(.systemGray6))
//            .cornerRadius(25)
//            .onChange(of: selectedIndex) { index in
//                withAnimation {
//                    scrollView.scrollTo(index, anchor: .center)
//                }
//            }
//        }
//
//    }
//}
//
//struct TabbarItem: View {
//    var name: String
//    var isActive: Bool = false
//    let namespace: Namespace.ID
// 
//    var body: some View {
//        if isActive {
//            Text(name)
//                .font(.subheadline)
//                .padding(.horizontal)
//                .padding(.vertical, 4)
//                .foregroundColor(.white)
//                .background(Capsule().foregroundColor(.purple))
//                .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
//        } else {
//            Text(name)
//                .font(.subheadline)
//                .padding(.horizontal)
//                .padding(.vertical, 4)
//                .foregroundColor(.black)
//        }
// 
//    }
//}
//
////struct BleSearchTableView_Previews: PreviewProvider {
////    static var previews: some View {
////        BleSearchTableView()
////
////        BleSearchTablebarView(tabbarItems: [ "Random", "Travel", "Wallpaper", "Food", "Interior Design" ]).previewDisplayName("TabBarView")
////    }
////}
