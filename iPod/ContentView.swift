//
//  ContentView.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

struct ContentView: View {
    @State var increment: Int = 0
    
    var body: some View {
        VStack {
            Text("\(increment)")
                .padding()
            WheelView(tick: { increment += $0 } )
                .foregroundColor(.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
