//
//  Pendulum.swift
//  DoublePendulumSimulator
//
//  Created by Tanish Jayachandran on 14/10/24.
//
import SwiftUI
import CoreGraphics

struct Pendulum {
    var length: CGFloat
    var mass: CGFloat
    var angle: CGFloat
    var angularVelocity: CGFloat
    var angularAcceleration: CGFloat
    
    init(length: CGFloat, mass: CGFloat, angle: CGFloat, angularVelocity: CGFloat = 0, angularAcceleration: CGFloat = 0) {
        self.length = length
        self.mass = mass
        self.angle = angle
        self.angularVelocity = angularVelocity
        self.angularAcceleration = angularAcceleration
    }
}
