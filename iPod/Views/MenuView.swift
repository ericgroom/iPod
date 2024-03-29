//
//  MenuView.swift
//  iPod
//
//  Created by Eric Groom on 2/15/21.
//

import SwiftUI

struct MenuView: View {
    let selection: MenuContent.Item
    let content: MenuContent
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(alignment: .leading, spacing: 0.0) {
                    ForEach(content.items, id: \.self) { item in
                        MenuItemView(title: item, isSelected: item == selection)
                    }
                }
                .onChange(of: selection, perform: { value in
                    proxy.scrollTo(value)
                })
            }
        }.disabled(true)
    }
}

struct MenuItemView: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
            Spacer()
            if isSelected {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .padding(.trailing, 5.0)
            }
        }
        .padding(4.0)
        .foregroundColor(isSelected ? .white : .black)
        .background(isSelected ? selectedBackground : deselectedBackground)
    }
    
    private var selectedBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color("selectionSecondary"),
                Color("selectionPrimary")
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var deselectedBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.clear]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(selection: "Music", content: MenuContent.default)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
