//
//  CGRect+Extensions.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

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

