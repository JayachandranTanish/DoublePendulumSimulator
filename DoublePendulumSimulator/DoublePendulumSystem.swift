//
//  DoublePendulumSystem.swift
//  DoublePendulumSimulator
//
//  Created by Tanish Jayachandran on 14/10/24.
//

import Combine
import SwiftUI

class DoublePendulumSystem: ObservableObject {
    @Published var pendulum1: Pendulum
    @Published var pendulum2: Pendulum
    private var timer: Timer?
    
    // Traces for pendulum bobs
    @Published var trace1 = PendulumTrace()
    @Published var trace2 = PendulumTrace()

    let g: CGFloat = 9.81

    init(pendulum1: Pendulum, pendulum2: Pendulum) {
        self.pendulum1 = pendulum1
        self.pendulum2 = pendulum2
    }

    func startSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.004, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updatePendulums()
        }
    }

    func stopSimulation() {
        timer?.invalidate()
        timer = nil
    }

    private func updatePendulums() {
        let m1 = pendulum1.mass
        let m2 = pendulum2.mass
        let L1 = pendulum1.length
        let L2 = pendulum2.length
        let a1 = pendulum1.angle
        let a2 = pendulum2.angle
        var v1 = pendulum1.angularVelocity
        var v2 = pendulum2.angularVelocity

        let num1 = -g * (2 * m1 + m2) * sin(a1)
        let num2 = -m2 * g * sin(a1 - 2 * a2)
        let num3 = -2 * sin(a1 - a2) * m2
        let num4 = v2 * v2 * L2 + v1 * v1 * L1 * cos(a1 - a2)
        let denom = L1 * (2 * m1 + m2 - m2 * cos(2 * a1 - 2 * a2))
        let a1Acc = (num1 + num2 + num3 * num4) / denom

        let num5 = 2 * sin(a1 - a2)
        let num6 = v1 * v1 * L1 * (m1 + m2)
        let num7 = g * (m1 + m2) * cos(a1)
        let num8 = v2 * v2 * L2 * m2 * cos(a1 - a2)
        let denom2 = L2 * (2 * m1 + m2 - m2 * cos(2 * a1 - 2 * a2))
        let a2Acc = (num5 * (num6 + num7 + num8)) / denom2

        // Update angular velocities and angles
        v1 += a1Acc * 0.016
        v2 += a2Acc * 0.016
        pendulum1.angularVelocity = v1
        pendulum2.angularVelocity = v2
        pendulum1.angle += pendulum1.angularVelocity * 0.016
        pendulum2.angle += pendulum2.angularVelocity * 0.016
        
        // Update traces with current positions
        let pendulum1X = 350 + pendulum1.length * sin(pendulum1.angle)
        let pendulum1Y = 350 + pendulum1.length * cos(pendulum1.angle)
        let pendulum2X = pendulum1X + pendulum2.length * sin(pendulum2.angle)
        let pendulum2Y = pendulum1Y + pendulum2.length * cos(pendulum2.angle)
        
        trace1.addPoint(CGPoint(x: pendulum1X, y: pendulum1Y))
        trace2.addPoint(CGPoint(x: pendulum2X, y: pendulum2Y))

        // Update published properties
        pendulum1 = pendulum1 // Triggers update due to value type
        pendulum2 = pendulum2
    }
}
