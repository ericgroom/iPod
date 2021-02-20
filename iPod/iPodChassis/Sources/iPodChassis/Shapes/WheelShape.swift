//
//  File.swift
//  
//
//  Created by Eric Groom on 2/20/21.
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

