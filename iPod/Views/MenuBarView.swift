//
//  MenuBarView.swift
//  iPod
//
//  Created by Eric Groom on 2/15/21.
//

import SwiftUI

struct MenuBarView: View {
    var body: some View {
        HStack {
            let gradient = LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)
            let playIcon = Image(systemName: "play.fill")
            playIcon
                .overlay(
                    gradient .mask(playIcon.scaledToFill())
                )
            Spacer()
            Text("iPod")
        }
        .padding(8)
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .init(white: 0.7)]), startPoint: .top, endPoint: .bottom)
        )
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
