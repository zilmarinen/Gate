//
//  Marionette.swift
//
//  Created by Zack Brown on 28/10/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

internal class Marionette<S: Skeleton>: SCNNode,
                                        Updatable {
    
    internal let skeleton: S
    
    required init(skeleton: S) {
        
        self.skeleton = skeleton
        
        super.init()
        
        addChildNode(skeleton)
        
        skeleton.bind()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Marionette {
    
    func update(delta: TimeInterval,
                time: TimeInterval) {
        
        let value = sin(time)
        
        //skeleton.childNode(skeleton.rootNode)?.rotation = SCNVector4(Quaternion.yaw(.radians(value)))
    }
}
