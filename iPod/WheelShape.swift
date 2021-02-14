//
//  WheelShape.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

struct MCircle {
    let center: CGPoint
    let radius: CGFloat
    
    static var zero: MCircle {
        MCircle(center: .zero, radius: .zero)
    }
    
    func nearestPoint(to point: CGPoint) -> CGPoint {
        // vector from center to point
        let vx = point.x - center.x
        let vy = point.y - center.y
        // magnitude of vector
        let mag = sqrt(vx*vx + vy*vy)
        // normalize vector, multiply it by radius and offset it from the center
        let ax = center.x + vx / mag * radius
        let ay = center.y + vy / mag * radius
        return CGPoint(x: ax, y: ay)
    }
}

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

struct PointShape: Shape {
    let point: CGPoint
    
    func path(in rect: CGRect) -> Path {
        Path(ellipseIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
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

extension CGRect {
    var center: CGPoint {
        CGPoint(x: self.midX, y: self.midY)
    }
    
    var squareRect: CGRect {
        let shortestSide = width > height ? height : width
        let size = CGSize(width: shortestSide, height: shortestSide)
        
        // if the rect is wider than tall:
        // move the x in by half of the leftover space
        let widthDifference = width - size.width
        let heightDifference = height - size.height
        let xOffset = widthDifference / 2
        let yOffset = heightDifference / 2
        let origin = CGPoint(x: xOffset, y: yOffset)
        
        return CGRect(origin: origin, size: size)
    }
}

struct WheelShape_Previews: PreviewProvider {
    static var previews: some View {
        WheelShape()
            .foregroundColor(.red)
    }
}
