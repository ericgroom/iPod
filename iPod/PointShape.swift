//
//  PointShape.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

struct PointShape: Shape {
    let point: CGPoint
    
    func path(in rect: CGRect) -> Path {
        Path(ellipseIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
    }
}

