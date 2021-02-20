//
//  File.swift
//  
//
//  Created by Eric Groom on 2/20/21.
//

import SwiftUI

struct WedgeButton<Content: View>: View {
    let edge: Edge
    let thickness: CGFloat
    let action: () -> Void
    let content: () -> Content
    private let debug = false
    
    var body: some View {
        Button(action: self.action, label: {
            ZStack(alignment: edge.alignment) {
                if debug {
                    wedge
                        .foregroundColor(edge.debugColor)
                } else {
                    wedge
                }
                content()
                    .offset(edge.offset)
                    .foregroundColor(Color("chassisPrimary"))
            }
        })
        .contentShape(wedge)
    }
    
    private var wedge: some Shape {
        WedgeShape(startAngle: edge.startAngle, endAngle: edge.endAngle, thickness: thickness, clockwise: false)
    }
    
    enum Edge {
        case top, left, right, bottom
        
        var debugColor: Color {
            switch self {
            case .top:
                return .red
            case .right:
                return .green
            case .bottom:
                return .blue
            case .left:
                return .yellow
            }
        }
        
        var startAngle: Angle {
            switch self {
            case .top:
                return Angle.zero - Angle.eighth
            case .right:
                return Angle.zero + Angle.eighth
            case .bottom:
                return -Angle.half - Angle.eighth
            case .left:
                return -Angle.half + Angle.eighth
            }
        }
        
        var endAngle: Angle {
            switch self {
            case .top:
                return -Angle.half + Angle.eighth
            case .right:
                return Angle.zero - Angle.eighth
            case .bottom:
                return Angle.zero + Angle.eighth
            case .left:
                return -Angle.half - Angle.eighth
            }
        }
        
        var offset: CGSize {
            switch self {
            case .top:
                return CGSize(width: 0, height: 10)
            case .right:
                return CGSize(width: -10, height: 0)
            case .bottom:
                return CGSize(width: 0, height: -10)
            case .left:
                return CGSize(width: 10, height: 0)
            }
        }
        
        var alignment: Alignment {
            switch self {
            case .top:
                return .top
            case .right:
                return .trailing
            case .bottom:
                return .bottom
            case .left:
                return .leading
            }
        }
    }
}
