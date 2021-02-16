//
//  WheelShape.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

/// Won't work properly if not displayed with a square aspect ratio
struct WheelShape: Shape {
    let thickness: CGFloat
    
    init(thickness: CGFloat) {
        self.thickness = thickness
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(center: rect.center, radius: rect.width / 2, startAngle: .zero, endAngle: .radians(2*Double.pi), clockwise: true)
            
            let innerRect = rect.insetBy(dx: thickness, dy: thickness)
            path.addEllipse(in: innerRect)
        }
    }
}

struct WheelView: View {
    
    enum UserInput {
        case menu
        case pause
        case skip
        case back
        case centerButton
        case drag(DragDirection)
    }
    enum DragDirection { case clockwise, counterClockwise }
    
    let userInput: (UserInput) -> ()
    private let angleForTick = Angle(radians: Double.pi/8)
    @State private var startPoint: CGPoint?

    private let wheelCoordSpace = "wheelSpace"

    var body: some View {
        GeometryReader { geometry in
            
            let drag = DragGesture(minimumDistance: 5.0, coordinateSpace: .named(wheelCoordSpace))
                .onChanged { dragValue in
                    dragUpdated(geometry: geometry, dragValue: dragValue)
                }
                .onEnded { dragValue in
                    dragEnded(dragValue)
                }
            let thickness = self.thickness(for: geometry)
            
            ZStack {
                WheelShape(thickness: thickness)
                    .coordinateSpace(name: wheelCoordSpace)
                WedgeButton(edge: .top, thickness: thickness, action: { userInput(.menu) }) {
                    Text("Menu")
                        .font(Font.system(size: 18, weight: .bold, design: .default).smallCaps())
                }
                    .highPriorityGesture(drag)
                WedgeButton(edge: .right, thickness: thickness, action: { userInput(.skip) }) {
                    Image(systemName: "forward.end.alt.fill")
                }
                    .highPriorityGesture(drag)
                WedgeButton(edge: .bottom, thickness: thickness, action: { userInput(.pause) }) {
                    Image(systemName: "playpause.fill")
                }
                    .highPriorityGesture(drag)
                WedgeButton(edge: .left, thickness: thickness, action: { userInput(.back) }) {
                    Image(systemName: "backward.end.alt.fill")
                }
                    .highPriorityGesture(drag)
                circleButton(for: geometry)
            }
                .foregroundColor(.white)
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
    
    private func dragUpdated(geometry: GeometryProxy, dragValue: DragGesture.Value) {
        let startPoint = self.startPoint ?? dragValue.startLocation
        self.startPoint = startPoint
        
        let mCircle = circle(for: geometry)
        
        let start = mCircle.nearestPoint(to: startPoint)
        let end = mCircle.nearestPoint(to: dragValue.location)
        let startR = mCircle.radians(to: start)
        let endR = mCircle.radians(to: end)
        
        // https://stackoverflow.com/a/2007279
        let signedDiff = atan2(sin(endR.radians - startR.radians), cos(endR.radians - startR.radians))
        
        if fabs(fabs(signedDiff) - angleForTick.radians) < 0.1 {
            let direction: DragDirection = signedDiff > 0 ? .counterClockwise : .clockwise
            userInput(.drag(direction))
            // TODO: should adjust by the remainder
            self.startPoint = dragValue.location
        }
    }
    
    private func dragEnded(_ dragValue: DragGesture.Value) {
        startPoint = nil
    }
    
    private func circle(for geometry: GeometryProxy) -> MCircle {
        let frame = geometry.frame(in: .local)
        let squaredFrame = frame.squareRect
        let thickness = self.thickness(for: geometry)
        return MCircle(center: squaredFrame.center, radius: (squaredFrame.width / 2) - (thickness / 2))
    }
    
    private func circleButton(for geometry: GeometryProxy) -> some View {
        let squareRect = geometry.frame(in: .local).squareRect
        let thickness = self.thickness(for: geometry)
        let inset = squareRect.insetBy(dx: thickness, dy: thickness)
        
        return Button(action: { userInput(.centerButton) }, label: {
            Color(red: 141.0 / 255.0, green: 217.0 / 255.0, blue: 196.0 / 255.0)
                .frame(width: inset.width, height: inset.height, alignment: .center)
                .clipShape(Circle())
        })
    }
    
    private func thickness(for geometry: GeometryProxy) -> CGFloat {
        let circleFrame = geometry.frame(in: .local).squareRect
        return circleFrame.width / 3
    }
}

struct WedgeButton<Content: View>: View {
    let edge: Edge
    let thickness: CGFloat
    let action: () -> Void
    let content: () -> Content
    private let debug = false
    
    var body: some View {
        Button(action: self.action, label: {
            ZStack(alignment: edge.alignment) {
                if debug {
                    wedge
                        .foregroundColor(edge.debugColor)
                } else {
                    wedge
                }
                content()
                    .offset(edge.offset)
                    .foregroundColor(Color(red: 141.0 / 255.0, green: 217.0 / 255.0, blue: 196.0 / 255.0))
            }
        })
        .contentShape(wedge)
    }
    
    private var wedge: some Shape {
        WedgeShape(startAngle: edge.startAngle, endAngle: edge.endAngle, thickness: thickness, clockwise: false)
    }
    
    enum Edge {
        case top, left, right, bottom
        
        var debugColor: Color {
            switch self {
            case .top:
                return .red
            case .right:
                return .green
            case .bottom:
                return .blue
            case .left:
                return .yellow
            }
        }
        
        var startAngle: Angle {
            switch self {
            case .top:
                return Angle.zero - Angle.eighth
            case .right:
                return Angle.zero + Angle.eighth
            case .bottom:
                return -Angle.half - Angle.eighth
            case .left:
                return -Angle.half + Angle.eighth
            }
        }
        
        var endAngle: Angle {
            switch self {
            case .top:
                return -Angle.half + Angle.eighth
            case .right:
                return Angle.zero - Angle.eighth
            case .bottom:
                return Angle.zero + Angle.eighth
            case .left:
                return -Angle.half - Angle.eighth
            }
        }
        
        var offset: CGSize {
            switch self {
            case .top:
                return CGSize(width: 0, height: 10)
            case .right:
                return CGSize(width: -10, height: 0)
            case .bottom:
                return CGSize(width: 0, height: -10)
            case .left:
                return CGSize(width: 10, height: 0)
            }
        }
        
        var alignment: Alignment {
            switch self {
            case .top:
                return .top
            case .right:
                return .trailing
            case .bottom:
                return .bottom
            case .left:
                return .leading
            }
        }
    }
}

struct WheelView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            WheelView(userInput: { _ in })
                .padding()
        }
    }
}
