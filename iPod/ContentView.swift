//
//  ContentView.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

struct ContentView: View {
    @State var value: Int = 0
    @State var lastEvent: String = "none"
    
    var body: some View {
        iPodChassisView(userInput: self.userInputReceived) {
            VStack {
                Text("\(value)")
                    .padding()
                Text("Last event: \(lastEvent)")
                    .padding()
                    .lineLimit(1)
            }
        }
    }
    
    func userInputReceived(_ userInput: WheelView.UserInput) {
        lastEvent = "\(userInput)"
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
            UISelectionFeedbackGenerator().selectionChanged()
        case .centerButton:
            value = 0
            fallthrough
        case .back, .menu, .pause, .skip:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1.0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
