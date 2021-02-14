//
//  WheelShape.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

/// Won't work properly if not displayed with a square aspect ratio
struct WheelShape: Shape {
    let thickness: CGFloat = 100
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(center: rect.center, radius: rect.width / 2, startAngle: .zero, endAngle: .radians(2*Double.pi), clockwise: true)
            
            let innerRect = rect.insetBy(dx: thickness, dy: thickness)
            path.addEllipse(in: innerRect)
        }
    }
}

struct WheelView: View {
    
    let thickness: CGFloat = 100
    @State var point: CGPoint = .zero
    @State var adjustedPoint: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.lightGray)
                WheelShape()
                    .gesture(
                        DragGesture(minimumDistance: 10.0, coordinateSpace: .local)
                            .onChanged { dragValue in
                                dragUpdated(geometry: geometry, dragValue: dragValue)
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
        point = dragValue.location
        let frame = geometry.frame(in: .local)
        let squaredFrame = frame.squareRect
        let mCircle = MCircle(center: squaredFrame.center, radius: (squaredFrame.width / 2) - (thickness / 2))
        let dragPoint = dragValue.location
        let nearestPoint = mCircle.nearestPoint(to: dragPoint)
        adjustedPoint = nearestPoint
    }
}

struct WheelShape_Previews: PreviewProvider {
    static var previews: some View {
        WheelShape()
            .foregroundColor(.red)
    }
}
