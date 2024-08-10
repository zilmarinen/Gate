//
//  Keyframe.swift
//
//  Created by Zack Brown on 09/08/2024.
//

import Euclid
import Foundation

internal struct Keyframe {
    
    internal let timestamp: TimeInterval
    internal let bone: Bone
    internal let transform: Transform
}
