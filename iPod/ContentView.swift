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
            WheelShape()
                .foregroundColor(.gray)
                .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local).onChanged { value in
                    self.location = value.location
                })
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
