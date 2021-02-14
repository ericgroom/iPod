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
    
    enum DragDirection { case clockwise, counterClockwise }
    
    let userInput: (DragDirection) -> ()
    let thickness: CGFloat = 100
    let angleForTick = Angle(radians: Double.pi/8)
    @State var point: CGPoint = .zero
    @State var adjustedPoint: CGPoint = .zero
    @State var startPoint: CGPoint?

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
                PointShape(point: point)
                    .foregroundColor(.red)
                PointShape(point: adjustedPoint)
                    .foregroundColor(.blue)
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
    
    func dragUpdated(geometry: GeometryProxy, dragValue: DragGesture.Value) {
        let startPoint = self.startPoint ?? dragValue.startLocation
        self.startPoint = startPoint
        point = dragValue.location
        let frame = geometry.frame(in: .local)
        let squaredFrame = frame.squareRect
        let mCircle = MCircle(center: squaredFrame.center, radius: (squaredFrame.width / 2) - (thickness / 2))
        let dragPoint = dragValue.location
        let nearestPoint = mCircle.nearestPoint(to: dragPoint)
        adjustedPoint = nearestPoint
        
        let start = mCircle.nearestPoint(to: startPoint)
        let end = mCircle.nearestPoint(to: dragValue.location)
        let startR = mCircle.radians(to: start)
        let endR = mCircle.radians(to: end)
        // https://stackoverflow.com/a/2007279
        let signedDiff = atan2(sin(endR.radians - startR.radians), cos(endR.radians - startR.radians))
        if fabs(fabs(signedDiff) - angleForTick.radians) < 0.1 {
            let direction: DragDirection = signedDiff > 0 ? .counterClockwise : .clockwise
            userInput(direction)
            // TODO: should adjust by the remainder
            self.startPoint = dragValue.location
        }
    }
    
    func dragEnded() {
        startPoint = nil
    }
}

struct WheelShape_Previews: PreviewProvider {
    static var previews: some View {
        WheelShape(thickness: 100)
            .foregroundColor(.red)
    }
}
