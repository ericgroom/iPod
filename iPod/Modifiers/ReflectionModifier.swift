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
                .init(color: .clear, location: reflectionHeightRatio),
                .init(color: .clear, location: 1.0)
            ]
        )
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
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
                        .offset(reflectionOffset(for: proxy))
                        .frame(width: reflectionSize.width, height: reflectionSize.height, alignment: .top)
                }
            )
    }
    
    private func reflectionOffset(for proxy: GeometryProxy) -> CGSize {
        let frame = proxy.frame(in: .local)
        return CGSize(width: 0, height: frame.height)
    }
    
    private func reflectionSize(for proxy: GeometryProxy) -> CGSize {
        let frame = proxy.frame(in: .local)
        let actualHeight = frame.height * reflectionHeightRatio
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
