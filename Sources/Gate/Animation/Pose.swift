//
//  Pose.swift
//
//  Created by Zack Brown on 10/08/2024.
//

import Euclid
import Foundation

internal struct Pose {
    
    internal let joint: Joint
    internal let transform: Transform
    
    internal init(_ joint: Joint,
                  _ transform: Transform) {
        
        self.joint = joint
        self.transform = transform
    }
}
