//
//  ContentView.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

struct ContentView: View {
    @State var value: Int = 0
    @State var content = ScreenContent<MenuContent>(title: "iPod", content: MenuContent.long)
    
    var body: some View {
        iPodChassisView(userInput: self.userInputReceived) {
            VStack(spacing: 0.0) {
                MenuBarView(title: content.title)
                MenuView(selection: menuSelection, content: content.content)
            }
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
            UISelectionFeedbackGenerator().selectionChanged()
        case .centerButton:
            value = 0
            fallthrough
        case .back, .menu, .pause, .skip:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1.0)
        }
        if value <= 0 {
            value = 0
        } else if value >= content.content.items.count-1 {
            value = content.content.items.count-1
        }
    }
    
    var menuSelection: MenuContent.Item {
        content.content.items[value]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
