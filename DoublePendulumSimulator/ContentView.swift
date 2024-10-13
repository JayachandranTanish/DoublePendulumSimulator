//
//  ContentView.swift
//  DoublePendulumSimulator
//
//  Created by Tanish Jayachandran on 14/10/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var system = DoublePendulumSystem(
        pendulum1: Pendulum(length: 150, mass: 1, angle: .pi),
        pendulum2: Pendulum(length: 150, mass: 1, angle: .pi-0.001)
    )

    let pivotX: CGFloat = 350
    let pivotY: CGFloat = 350

    var body: some View {
        ZStack {
            drawTrace(points: system.trace1.points, color: Color.blue)
            drawTrace(points: system.trace2.points, color: Color.red)

            Circle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
                .position(x: pivotX, y: pivotY)

            let pendulum1X = pivotX + system.pendulum1.length * sin(system.pendulum1.angle)
            let pendulum1Y = pivotY + system.pendulum1.length * cos(system.pendulum1.angle)

            Line(from: CGPoint(x: pivotX, y: pivotY),
                 to: CGPoint(x: pendulum1X, y: pendulum1Y))
                .stroke(Color.blue, lineWidth: 2)

            Circle()
                .fill(Color.blue)
                .frame(width: system.pendulum1.mass * 15, height: system.pendulum1.mass * 15)
                .position(x: pendulum1X, y: pendulum1Y)

            let pendulum2X = pendulum1X + system.pendulum2.length * sin(system.pendulum2.angle)
            let pendulum2Y = pendulum1Y + system.pendulum2.length * cos(system.pendulum2.angle)

            Line(from: CGPoint(x: pendulum1X, y: pendulum1Y),
                 to: CGPoint(x: pendulum2X, y: pendulum2Y))
                .stroke(Color.red, lineWidth: 2)

            Circle()
                .fill(Color.red)
                .frame(width: system.pendulum2.mass * 15, height: system.pendulum2.mass * 15)
                .position(x: pendulum2X, y: pendulum2Y)
        }
        .onAppear {
            system.startSimulation()
        }
        .onDisappear {
            system.stopSimulation()
        }
        .animation(.linear(duration: 0.016), value: system.pendulum1.angle)
    }

    private func drawTrace(points: [CGPoint], color: Color) -> some View {
        Path { path in
            guard points.count > 1 else { return }
            for index in 0..<points.count {
                let point = points[index]
                // Set the opacity based on age of the point
                let opacity = 1.0 - CGFloat(index) / CGFloat(points.count)
                path.addEllipse(in: CGRect(x: point.x, y: point.y, width: 4, height: 4).offsetBy(dx: -2, dy: -2))
            }
        }
        .fill(color.opacity(0.5)) // Apply fill here with opacity
    }

}

struct Line: Shape {
    var from: CGPoint
    var to: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
}

