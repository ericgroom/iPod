//
//  ReflectionModifier.swift
//  iPod
//
//  Created by Eric Groom on 2/20/21.
//

import SwiftUI

struct ReflectionModifier: ViewModifier {
    
    let reflectionHeightRatio: CGFloat
    
    private var maskGradient: Gradient {
        Gradient(
            stops: [
                .init(color: Color.white.opacity(0.6), location: 0.0),
                .init(color: .clear, location: reflectionHeightRatio)
            ]
        )
    }
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            VStack(spacing: 0.0) {
                content

                let reflectionSize = self.reflectionSize(for: proxy)
                content
                    .rotationEffect(.radians(Double.pi))
                    .mask(
                        LinearGradient(
                            gradient: maskGradient,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .aspectRatio(contentMode: .fill)
                    .frame(width: reflectionSize.width, height: reflectionSize.height, alignment: .top)
                    .clipped()
                Spacer()
            }
        }
    }
    
    private func reflectionSize(for proxy: GeometryProxy) -> CGSize {
        let frame = proxy.frame(in: .local)
        let halfHeight = frame.height / 2
        let actualHeight = halfHeight * reflectionHeightRatio
        return CGSize(width: frame.width, height: actualHeight)
    }
}

extension View {
    /**
     Adds a reflection below the modified view
     - Parameter reflectionHeightRatio: height of the reflection relative to the view, 1.0 is equal, 0.5 is half, etc.
     */
    func reflection(reflectionHeightRatio: CGFloat = 1.0) -> some View {
        self.modifier(ReflectionModifier(reflectionHeightRatio: reflectionHeightRatio))
    }
}
