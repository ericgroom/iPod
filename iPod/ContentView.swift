//
//  ContentView.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            WheelView()
                .foregroundColor(.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
