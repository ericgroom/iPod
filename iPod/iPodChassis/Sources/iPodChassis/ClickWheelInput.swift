//
//  File.swift
//  
//
//  Created by Eric Groom on 2/20/21.
//

import Foundation

public enum ClickWheelInput {
    case menu
    case pause
    case skip
    case back
    case centerButton
    case drag(DragDirection)
}

public enum DragDirection { case clockwise, counterClockwise }

