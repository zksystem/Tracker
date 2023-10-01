//
//  CGPointCoords.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 30.09.2023.
//

import Foundation

extension CGPoint {
    
    enum CoordinateSide {
        case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left
    }
    
    static func unitCoordinate(_ side: CoordinateSide) -> CGPoint {
        let x: CGFloat
        let y: CGFloat

        switch side {
        case .topLeft:      x = 0.0; y = 0.0
        case .top:          x = 0.5; y = 0.0
        case .topRight:     x = 1.0; y = 0.0
        case .right:        x = 0.0; y = 0.5
        case .bottomRight:  x = 1.0; y = 1.0
        case .bottom:       x = 0.5; y = 1.0
        case .bottomLeft:   x = 0.0; y = 1.0
        case .left:         x = 1.0; y = 0.5
        }
        return .init(x: x, y: y)
    }
}
