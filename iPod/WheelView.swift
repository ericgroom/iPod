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
        case centerButton
        case drag(DragDirection)
    }
    enum DragDirection { case clockwise, counterClockwise }
    
    let userInput: (UserInput) -> ()
    let thickness: CGFloat = 80
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
            
            ZStack {
                WheelShape(thickness: thickness)
                    .coordinateSpace(name: wheelCoordSpace)
                    .foregroundColor(.gray)
                WedgeButton(edge: .top, thickness: thickness)
                    .highPriorityGesture(drag)
                circleButton(for: geometry)
            }
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
        return MCircle(center: squaredFrame.center, radius: (squaredFrame.width / 2) - (thickness / 2))
    }
    
    private func circleButton(for geometry: GeometryProxy) -> some View {
        let squareRect = geometry.frame(in: .local).squareRect
        let inset = squareRect.insetBy(dx: thickness, dy: thickness)
        
        return Button(action: { userInput(.centerButton) }, label: {
            Color(white: 0.8)
                .frame(width: inset.width, height: inset.height, alignment: .center)
                .clipShape(Circle())
        })
    }
}

struct WedgeButton: View {
    let edge: Edge
    let thickness: CGFloat
    
    var body: some View {
        Button(action: {print("hi")}, label: {
            ZStack(alignment: .top) {
                wedge
                    .foregroundColor(.blue)
                Text("Menu")
                    .offset(edge.offset)
                    .foregroundColor(.black)
            }
            .contentShape(wedge)
        })
    }
    
    private var wedge: some Shape {
        WedgeShape(startAngle: edge.startAngle, endAngle: edge.endAngle, thickness: thickness, clockwise: false)
    }
    
    enum Edge {
        case top, left, right, bottom
        
        private static let quarter = Angle(radians: Double.pi/2)
        private static let half = Angle(radians: Double.pi)
        private static let eighth = Angle(radians: Double.pi/4)
        
        var startAngle: Angle {
            switch self {
            case .top:
                return Angle.zero - Self.eighth
            default:
                fatalError("todo")
            }
        }
        
        var endAngle: Angle {
            switch self {
            case .top:
                return -Self.half + Self.eighth
            default:
                fatalError("todo")
            }
        }
        
        var offset: CGSize {
            switch self {
            case .top:
                return CGSize(width: 0, height: 10)
            default:
                fatalError("todo")
            }
        }
    }
}

struct WheelView_Previews: PreviewProvider {
    static var previews: some View {
        WheelView(userInput: { _ in })
    }
}
