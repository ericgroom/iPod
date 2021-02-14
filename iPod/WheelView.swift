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
        case drag(DragDirection)
    }
    enum DragDirection { case clockwise, counterClockwise }
    
    let userInput: (UserInput) -> ()
    let thickness: CGFloat = 100
    private let angleForTick = Angle(radians: Double.pi/8)
    @State private var startPoint: CGPoint?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.lightGray)
                WheelShape(thickness: thickness)
                    .gesture(
                        DragGesture(minimumDistance: 10.0, coordinateSpace: .local)
                            .onChanged { dragValue in
                                dragUpdated(geometry: geometry, dragValue: dragValue)
                            }
                            .onEnded { _ in
                                dragEnded()
                            }
                    )
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
    
    private func dragEnded() {
        startPoint = nil
    }
    
    private func circle(for geometry: GeometryProxy) -> MCircle {
        let frame = geometry.frame(in: .local)
        let squaredFrame = frame.squareRect
        return MCircle(center: squaredFrame.center, radius: (squaredFrame.width / 2) - (thickness / 2))
    }
}

struct WheelView_Previews: PreviewProvider {
    static var previews: some View {
        WheelView(userInput: { _ in })
    }
}
