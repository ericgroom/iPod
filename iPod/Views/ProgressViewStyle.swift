//
//  ProgressViewStyle.swift
//  iPod
//
//  Created by Eric Groom on 2/20/21.
//

import SwiftUI

struct iPodSongProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        let progress: CGFloat = configuration.fractionCompleted.map(CGFloat.init(_:)) ?? 0.0
        
        return Rectangle()
            .frame(height: 25)
            .overlay(
                GeometryReader { proxy in
                    Color.blue.blendMode(.hardLight)
                        .clipShape(Rectangle())
                        .frame(width: proxy.size.width * progress)
                }.background(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [Color.white, Color.gray, Color.white]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            )
    }
}

struct iPodSongProgressViewStyle_Previews: PreviewProvider {
    
    static let progressValues: [Double] = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    
    static var previews: some View {
        Group {
            ForEach(progressValues, id: \.self) { value in
                ProgressView(value: value)
            }
        }
            .progressViewStyle(iPodSongProgressViewStyle())
            .previewLayout(.sizeThatFits)
    }
}
