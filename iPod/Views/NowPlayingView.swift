//
//  NowPlayingView.swift
//  iPod
//
//  Created by Eric Groom on 2/20/21.
//

import SwiftUI

struct NowPlayingView: View {
    var body: some View {
        VStack {
            HStack() {
                AlbumView()
                VStack(alignment: .leading) {
                    Text("Goodbye To a World")
                        .bold()
                    Text("Porter Robinson")
                    Text("Worlds")
                }
            }
            HStack {
                Text("0:18")
                ProgressView(value: 0.5)
                    .progressViewStyle(iPodSongProgressViewStyle())
                Text("-3:18")
            }
        }.padding()
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingView()
            .previewLayout(.fixed(width: 500, height: 500))
    }
}
