//
//  AlbumView.swift
//  iPod
//
//  Created by Eric Groom on 2/20/21.
//

import SwiftUI

struct AlbumView: View {
    var body: some View {
        Image("worlds")
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
            .reflection(reflectionHeightRatio: 0.5)
            .rotation3DEffect(
                .init(degrees: 10),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
    }
    
    private func size(for proxy: GeometryProxy) -> CGSize {
        let frame = proxy.frame(in: .local)
        let minSide = min(frame.width, frame.height)
        return CGSize(width: minSide, height: minSide)
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView()
            .padding()
    }
}
