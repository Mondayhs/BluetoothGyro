////
////  For test.swift
////  BLE_test
////
////  Created by zhou Chou on 2023/7/3.
////
//
import SwiftUI
import SceneKit
import Charts
import UIKit

struct Workout: Identifiable, Hashable {
    var id = UUID()
    var day: String
    var minutes: Int
}
extension Workout {
    static var walkData: [Workout] {
        [
            .init(day: "Mon", minutes: 23),
            .init(day: "Tue", minutes: 45),
            .init(day: "Wed", minutes: 76),
            .init(day: "Thu", minutes: 21),
            .init(day: "Fri", minutes: 15),
            .init(day: "Sat", minutes: 35),
            .init(day: "Sun", minutes: 10)
        ]
    }

    static var runData: [Workout] {
        [
            .init(day: "Mon", minutes: 33),
            .init(day: "Tue", minutes: 12),
            .init(day: "Wed", minutes: 45),
            .init(day: "Thu", minutes: 54),
            .init(day: "Fri", minutes: 87),
            .init(day: "Sat", minutes: 32),
            .init(day: "Sun", minutes: 45)
        ]
    }
}
import Model3DView

struct For_test: View {
    
//    let workouts = [(workoutType: "Walk", data: Workout.walkData),(workoutType: "Run", data: Workout.runData)]
    @State private var TransmitDataX = ""
    @State private var TransmitDataY = ""
    @State private var TransmitDataZ = ""
    @FocusState private var nameIsFocused: Bool
    @State private var degreeX: Double = 0
    @State private var degreeY: Double = 0
    @State private var degreeZ: Double = 0
    
    var body: some View {
        
        
        VStack{
            HStack(spacing: 5) {
                TextField("Input X", text: $TransmitDataX)
                    .keyboardType(.numberPad)
                    .focused($nameIsFocused)
                TextField("Input Y", text: $TransmitDataY)
                    .keyboardType(.numberPad)
                    .focused($nameIsFocused)
                TextField("Input Z", text: $TransmitDataZ)
                    .keyboardType(.numberPad)
                    .focused($nameIsFocused)

                Button{
                    nameIsFocused = false
                    print(TransmitDataX, TransmitDataY, TransmitDataZ)
                    degreeX  = Double(TransmitDataX) ?? 0.0
                    degreeY  = Double(TransmitDataY) ?? 0.0
                    degreeZ  = Double(TransmitDataZ) ?? 0.0
                }label: {
                    HStack{
                        Text("Confirm")
                    }   // End HStack
                }   // End button label
            }
            ZStack {
                ZStack {
                    ZStack {
                        Text("Y")
                            .offset(.init(width: 180, height: 0))
                        SceneKitView(radius: 0.01, height: 1, angle: Angle(degrees: 0), color: Color.blue)
                            .opacity(0.2)
//                            .offset(.init(width: 150, height: 90))
                            .rotation3DEffect(.degrees(90), axis: (x: 0, y: 0, z: 1), anchor: .center, perspective: -0.1)
                            
                    }
                    HStack {
                        Text("X")
                            .offset(.init(width: -100, height: 0))
                        SceneKitView(radius: 0.05, height: 5, angle: Angle(degrees: 0), color: Color.red)
                            .opacity(0.2)
                            .rotation3DEffect(.degrees(80), axis: (x: 0, y: 0, z: 1), anchor: .center, perspective: -0.1)
                    }
                    
                    .rotation3DEffect(.degrees(-65), axis: (x: 0, y: 1, z: 0), anchor: .center, perspective: -0.1)
//                    .offset(CGSize(width: -90, height: 0))
                    Spacer()
                    ZStack {
                        Text("Z")
                            .offset(.init(width: 2, height: -200))
                        SceneKitView(radius: 0.01, height: 2, angle: Angle(degrees: 0), color: Color.green)
                            .opacity(0.2)
                    }
                }
                Model3DView(named: "toy_biplane_idle.usdz")
                    .transform(scale: 0.3)
                    .rotation3DEffect(.degrees(degreeZ), axis: (x: 0, y: 0, z: 1))
                    .rotation3DEffect(.degrees(degreeX), axis: (x: 1, y: 0, z: 0))
                    .rotation3DEffect(.degrees(degreeY), axis: (x: 0, y: 1, z: 0))
                
            }
            .frame(width: 200, height: 400)

        }
    }
}

//SceneKit View

struct SceneKitView: UIViewRepresentable {
    

    var angle: Angle

    let cylindernode: SCNNode

    init(radius: CGFloat, height: CGFloat, angle: Angle, color: Color) {
        
        let cylinder = SCNCylinder(radius: CGFloat(radius), height: height)
        cylinder.firstMaterial?.diffuse.contents = UIColor(color)
        self.cylindernode = SCNNode(geometry: cylinder)
        self.cylindernode.position = SCNVector3(0, 0, 0)
        self.cylindernode.orientation = SCNVector4(0, 0, 0, 0)
        cylindernode.pivot = SCNMatrix4MakeTranslation(0, -1, 0)
        
        self.angle = angle
    }
    func makeUIView(context: UIViewRepresentableContext<SceneKitView>) -> SCNView {

        let sceneView = SCNView()
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.scene?.rootNode.addChildNode(cylindernode)
        return sceneView
    }

    func updateUIView(_ sceneView: SCNView, context: UIViewRepresentableContext<SceneKitView>) {

     //Rotation animation

        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.isRemovedOnCompletion = false
        rotation.duration = 5
        cylindernode.addAnimation(rotation, forKey: "rotation")
        cylindernode.rotation = SCNVector4(1, 0, 0, angle.radians)

    }
    
}


//struct For_test_Previews: PreviewProvider {
//    static var previews: some View {
//        For_test()
//    }
//}

//struct BoxView: View {
//
//    @State private var degrees: Double = 30
//
//  var body: some View {
//
//
//      ZStack {
//          ZStack {
//              SceneView(scene: SCNScene(named: "toy_biplane_idle.usdz"))
//                  .frame(width: 120, height: 120, alignment: .center)
//                  .offset(.init(width: -15, height: 0))
//          }
//          .rotation3DEffect(.degrees(-50), axis: (x: 0, y: 1, z: 0), anchor: UnitPoint.trailing, anchorZ: 0, perspective: -0.1)
//          ZStack {
//              Text("Y")
//                  .offset(.init(width: 200, height: 0))
//              Rectangle()
//                  .stroke(Color.blue, lineWidth: 5)
//                  .opacity(0.2)
//                  .frame(width: 350, height: 1, alignment: .center)
//          }
//          ZStack {
//              Text("X")
//                .offset(.init(width: -100, height: 0))
//              Rectangle()
//                .stroke(Color.red, lineWidth: 5)
//                .opacity(0.2)
//                .frame(width: 320, height: 1, alignment: .center)
//          }
//          .rotation3DEffect(.degrees(-50), axis: (x: 0, y: 1, z: 0), anchor: UnitPoint.trailing, perspective: -0.1)
//          .offset(CGSize(width: -90, height: 0))
//                  Spacer()
//          ZStack {
//              Text("Z")
//                  .offset(.init(width: 2, height: -200))
//              Rectangle()
//                  .stroke(Color.green, lineWidth: 5)
//                  .opacity(0.2)
//                  .frame(width: 1, height: 350, alignment: .center)
//          }
//      }
//
//
//  }
//}
//
//struct Previews_For_test_Previews: PreviewProvider {
//    static var previews: some View {
//        BoxView()
//    }
//}



//
//  FollowFinger.swift
//
//  SwiftUI Modifier for 3D rotation when touching
//
//  Created by Kevin Peplinski on 30.01.21.
//  Copyright © 2021 Kevin Peplinski. All rights reserved.
//
//import Foundation
//import SwiftUI
//
//extension View {
//    @ViewBuilder
//    func followFinger() -> some View {
//        self.modifier(FollowFingerModifier())
//    }
//}
//
//fileprivate struct FollowFingerModifier: ViewModifier {
//
//    @State private var point = CGPoint(x: 0, y: 0)
//    @State private var degrees: Double = 0
//    @State private var draging: Bool = false
//
//    func body(content: Content) -> some View {
//        GeometryReader { proxy in
//            content
//                .rotation3DEffect(.degrees(degrees), axis: (x: point.x, y: point.y, z: 0))
//                .simultaneousGesture(
//                    DragGesture(minimumDistance: 0)
//                        .onChanged({ gesture in
//                            let centerX = proxy.size.width / 2
//                            let centerY = proxy.size.height / 2
//
//                            let x = 0 - (gesture.location.y / centerY - 1)
//                            let y = (gesture.location.x / centerX - 1)
//
//                            let x1 = gesture.location.x - centerX
//                            let y1 = gesture.location.y - centerY
//
//                            let range = sqrt(x1 * x1 + y1 * y1)
//                            let degreesFactor = range / sqrt(2 * centerX * centerX)
//
//                            withAnimation {
//                                point = CGPoint(x: x, y: y)
//                                degrees = Double(30 * degreesFactor.clamped(0, 1))
//                            }
//                            draging = true
//                        })
//                        .onEnded(onDragEndedAction(gesture:))
//                )
//        }
//    }
//
//    private func onDragEndedAction(gesture: DragGesture.Value) -> Void {
//        withAnimation {
//            point = CGPoint(x: 0, y: 0)
//            degrees = 0
//        }
//        draging = false
//    }
//}
//
//fileprivate extension Comparable {
//    func clamped(_ f: Self, _ t: Self)  ->  Self {
//        var r = self
//        if r < f { r = f }
//        if r > t { r = t }
//        return r
//    }
//}

