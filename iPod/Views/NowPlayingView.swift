//
//  NowPlayingView.swift
//  iPod
//
//  Created by Eric Groom on 2/20/21.
//

import SwiftUI

typealias Seconds = Int

struct PlaybackInfo {

    let song: String
    let artist: String
    let album: Album
    let playbackProgress: PlaybackProgres
}

struct Album {
    let name: String
    let image: Image
}

struct PlaybackProgres {
    let lengthPlayed: Seconds
    let totalLength: Seconds
    
    var percentageComplete: Double {
        guard totalLength != 0 else { return 0.0 }
        
        return Double(lengthPlayed) / Double(totalLength)
    }
    
    var lengthPlayedFormatted: String {
        let minutes = lengthPlayed / 60
        let seconds = lengthPlayed % 60
        
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
    
    var lengthToEndFormatted: String {
        let minutes = (totalLength - lengthPlayed) / 60
        let seconds = (totalLength - lengthPlayed) % 60
        
        return "-\(minutes):\(String(format: "%02d", seconds))"
    }
}

struct NowPlayingView: View {
    
    let playbackInfo: PlaybackInfo

    var body: some View {
        VStack {
            HStack {
                AlbumView(image: playbackInfo.album.image)
                VStack(alignment: .leading) {
                    Text(playbackInfo.song)
                        .bold()
                    Text(playbackInfo.artist)
                    Text(playbackInfo.album.name)
                }
            }.padding()
            Spacer()
            HStack {
                Text(playbackInfo.playbackProgress.lengthPlayedFormatted)
                ProgressView(value: playbackInfo.playbackProgress.percentageComplete)
                    .progressViewStyle(iPodSongProgressViewStyle())
                Text(playbackInfo.playbackProgress.lengthToEndFormatted)
            }
        }.padding()
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static let playbackInfo: PlaybackInfo = .init(
        song: "Goodbye to a World",
        artist: "Porter Robinson",
        album: .init(name: "Worlds", image: Image("worlds")),
        playbackProgress: .init(lengthPlayed: 18, totalLength: 199)
    )
    
    static var previews: some View {
        NowPlayingView(playbackInfo: playbackInfo)
            .previewLayout(.fixed(width: 500, height: 500))
    }
}
