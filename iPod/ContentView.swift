//
//  ContentView.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

struct ContentView: View {
    @State var location: CGPoint?
    
    var body: some View {
        VStack {
            Text(locationText)
                .padding()
            Circle()
                .foregroundColor(.gray)
                .frame(width: 300, height: 300, alignment: .center)
                .gesture(
                    DragGesture(minimumDistance: 10.0, coordinateSpace: .local)
                        .onChanged { value in
                            self.location = value.location
                        }
                )
        }
    }
    
    var locationText: String {
        location.map { point in
            "\(point.x), \(point.y)"
        } ?? "none"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
