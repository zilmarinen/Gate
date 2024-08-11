//
//  Keyframe.swift
//
//  Created by Zack Brown on 09/08/2024.
//

import Euclid
import Foundation

internal struct Keyframe {
    
    internal let timestamp: TimeInterval
    internal let poses: [Pose]
}

extension Keyframe {
    
    internal var joints: [Joint] { poses.map { $0.joint } }
    
    internal func pose(_ joint: Joint) -> Pose? { poses.first { $0.joint == joint } }
}
