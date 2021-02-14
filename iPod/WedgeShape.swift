//
//  WedgeShape.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

struct WedgeShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let thickness: CGFloat
    let clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let outerRadius = rect.size.width/2
        let innerRadius = outerRadius - thickness
        path.addArc(center: rect.center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        path.addArc(center: rect.center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: clockwise)
        path.closeSubpath()
        return path
    }
}

struct WedgeShape_Previews: PreviewProvider {
    static let quarter = Angle(radians: Double.pi/2)
    static let half = Angle(radians: Double.pi)
    static let eighth = Angle(radians: Double.pi/4)
    
    static var previews: some View {
        ZStack {
            WedgeShape(
                startAngle: Angle.zero - eighth,
                endAngle: -half + eighth,
                thickness: 100,
                clockwise: false
            )
                .frame(width: 300, height: 300, alignment: .center)
                .foregroundColor(.green)
            WedgeShape(
                startAngle: -half + eighth,
                endAngle: -half - eighth,
                thickness: 100,
                clockwise: false
            )
                .frame(width: 300, height: 300, alignment: .center)
                .foregroundColor(.red)
        }
    }
}
