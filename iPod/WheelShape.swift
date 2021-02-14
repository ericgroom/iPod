//
//  WheelShape.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

struct WheelShape: Shape {
    
    let thickness: CGFloat = 100
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let outerRect = squareRect(in: rect)
            path.addArc(center: outerRect.center, radius: outerRect.width / 2, startAngle: .zero, endAngle: .radians(2*Double.pi), clockwise: true)
            
            let innerRect = outerRect.insetBy(dx: thickness, dy: thickness)
            path.addEllipse(in: innerRect)
        }
    }
    
    func squareRect(in rect: CGRect) -> CGRect {
        let shortestSide = rect.width > rect.height ? rect.height : rect.width
        let size = CGSize(width: shortestSide, height: shortestSide)
        
        // if the rect is wider than tall:
        // move the x in by half of the leftover space
        let widthDifference = rect.width - size.width
        let heightDifference = rect.height - size.height
        let xOffset = widthDifference / 2
        let yOffset = heightDifference / 2
        let origin = CGPoint(x: xOffset, y: yOffset)
        
        return CGRect(origin: origin, size: size)
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: self.midX, y: self.midY)
    }
}

struct WheelShape_Previews: PreviewProvider {
    static var previews: some View {
        WheelShape()
            .foregroundColor(.red)
    }
}
