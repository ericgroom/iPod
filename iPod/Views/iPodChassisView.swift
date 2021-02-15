//
//  iPodChassisView.swift
//  iPod
//
//  Created by Eric Groom on 2/15/21.
//

import SwiftUI

struct iPodChassisView<Content: View>: View {
    
    let userInput: (WheelView.UserInput) -> ()
    let screenContent: () -> Content
    
    var body: some View {
        ZStack {
            let gradient = Gradient(colors: [
                Color(red: 141.0 / 255.0, green: 217.0 / 255.0, blue: 196.0 / 255.0),
                Color(red: 50.0 / 255.0, green: 168 / 255.0, blue: 115 / 255.0)
            ])
            RadialGradient(gradient: gradient, center: .top, startRadius: 50, endRadius: 1000)
                .ignoresSafeArea()
            VStack {
                ZStack {
                    let screenShape = RoundedRectangle(cornerRadius: 8.0)
                    screenShape
                        .foregroundColor(Color(white: 0.95))
                    screenContent()
                        .clipShape(screenShape)
                }
                .aspectRatio(1.0, contentMode: .fit)
                Spacer()
                WheelView(userInput: self.userInput)
                    .padding(30)
            }
            .padding()
        }
    }
}

struct iPodChassisView_Previews: PreviewProvider {
    static var previews: some View {
        iPodChassisView(userInput: {_ in}) {
            Text("hi")
        }
    }
}
