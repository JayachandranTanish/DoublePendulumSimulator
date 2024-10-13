//
//  PendulumTrace.swift
//  DoublePendulumSimulator
//
//  Created by Tanish Jayachandran on 14/10/24.
//

import SwiftUI

struct PendulumTrace {
    var points: [CGPoint]
    
    init() {
        self.points = []
    }
    
    mutating func addPoint(_ point: CGPoint) {
        points.append(point)
        // Limit the number of points to maintain performance
        if points.count > 1000 {
            points.removeFirst() // Remove the oldest point
        }
    }
}

