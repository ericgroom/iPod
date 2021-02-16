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
                Color("chassisPrimary"),
                Color("chassisSecondary")
            ])
            RadialGradient(gradient: gradient, center: .top, startRadius: 50, endRadius: 1000)
                .ignoresSafeArea()
            VStack {
                ScreenView(screenContent: screenContent)
                Spacer()
                WheelView(userInput: self.userInput)
                    .padding(30)
            }
            .padding()
        }
    }
}

struct ScreenView<Content: View>: View {
    
    let screenContent: () -> Content
    
    var body: some View {
        let screenShape = RoundedRectangle(cornerRadius: 8.0)
        
        ZStack {
            Color.black
                .clipShape(screenShape)
            ZStack {
                screenShape
                    .foregroundColor(Color(white: 0.95))
                screenContent()
                    .clipShape(screenShape)
            }.padding(4)
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
