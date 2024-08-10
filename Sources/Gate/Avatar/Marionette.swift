//
//  Marionette.swift
//
//  Created by Zack Brown on 28/10/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

internal class Marionette: SCNNode,
                           Updatable {
    
    internal let skeleton: Skeleton
    
    required init(_ skeleton: Skeleton) {
        
        self.skeleton = skeleton
        
        super.init()
        
        addChildNode(skeleton)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Marionette {
    
    func update(_ delta: TimeInterval,
                _ time: TimeInterval) {
        
//        let value = sin(time)
//        
//        skeleton.childNode(.leftKnee)?.rotation = SCNVector4(Rotation.pitch(.radians(value)))
    }
}
