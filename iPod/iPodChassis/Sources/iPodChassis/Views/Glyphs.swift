//
//  File.swift
//  
//
//  Created by Eric Groom on 2/20/21.
//

import SwiftUI

struct MenuGlyph: View {
    var body: some View {
        Text("Menu")
            .font(Font.system(size: 18, weight: .bold, design: .default).smallCaps())
    }
}

struct SkipGlyph: View {
    var body: some View {
        Image(systemName: "forward.end.alt.fill")
    }
}

struct PlayPauseGlyph: View {
    var body: some View {
        Image(systemName: "playpause.fill")
    }
}

struct BackGlyph: View {
    var body: some View {
        Image(systemName: "backward.end.alt.fill")
    }
}

struct Glyph_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MenuGlyph()
            SkipGlyph()
            PlayPauseGlyph()
            BackGlyph()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
