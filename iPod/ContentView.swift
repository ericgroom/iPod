//
//  ContentView.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

struct ContentView: View {
    @State var value: Int = 0
    
    var body: some View {
        VStack {
            Text("\(value)")
                .padding()
            WheelView(userInput: self.userInputReceived(_:))
                .foregroundColor(.gray)
        }
    }
    
    func userInputReceived(_ userInput: WheelView.UserInput) {
        switch userInput {
        case .drag(let direction):
            let increment: Int
            switch direction {
            case .clockwise:
                increment = 1
            case .counterClockwise:
                increment = -1
            }
            value += increment
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
