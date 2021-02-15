//
//  MCircle.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import Foundation
import SwiftUI

struct MCircle {
    // TODO: don't use UI types
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
    
    func radians(to point: CGPoint) -> Angle {
        let negPiToPi = atan2(point.y - center.y, point.x - center.x)
        let radiansInversed = negPiToPi < 0 ? negPiToPi + 2*CGFloat.pi : negPiToPi
        let radians = 2*CGFloat.pi - radiansInversed
        return Angle(radians: Double(radians))
    }
}

