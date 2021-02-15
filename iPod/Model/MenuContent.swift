//
//  MenuContent.swift
//  iPod
//
//  Created by Eric Groom on 2/15/21.
//

import Foundation

struct MenuContent {
    typealias Item = String
    let items: [Item]
    
    static let `default` = MenuContent(items: [
        "Music",
        "Videos",
        "Photos",
        "Podcasts",
        "Extras",
        "Settings",
        "Shuffle Songs",
        "Now Playing"
    ])
}
