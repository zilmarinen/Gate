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
    
    internal var animation: Animation?
    
    internal let skeleton: Skeleton
    
    required init(_ skeleton: Skeleton) {
        
        self.skeleton = skeleton
        
        super.init()
        
        addChildNode(skeleton)
        
        let frames = [Keyframe(timestamp: 0,
                               poses: [.init(.leftKnee,
                                             .rotation(.identity))]),
                      Keyframe(timestamp: 2,
                               poses: [.init(.leftKnee,
                                             .rotation(.pitch(.halfPi)))])]
        
        self.animation = Animation(frames,
                                   true)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Marionette {
    
    internal func update(_ delta: TimeInterval,
                         _ time: TimeInterval) {
        
        guard let animation else { return }
        
        animation.update(delta,
                         time)
        
        for joint in skeleton.controlPoints {
            
            guard let node = skeleton.joint(joint),
                  let tPose = skeleton.tPose[joint] else { fatalError("Missing skeleton joint: \(joint.id)") }
            
            guard let previousFrame = animation.previousFrame(joint),
                  let previousPose = previousFrame.pose(joint),
                  let nextFrame = animation.nextFrame(joint),
                  let nextPose = nextFrame.pose(joint) else {
                
                //node.transform = SCNMatrix4(tPose)
                
                continue
            }
            
            let previousTransform = tPose * previousPose.transform
            let nextTransform = tPose * nextPose.transform
            
            let duration = nextFrame.timestamp - previousFrame.timestamp
            let playhead = animation.playhead - previousFrame.timestamp
            let interpolator = (1.0 / duration) * playhead
            
            //node.transform = SCNMatrix4(previousTransform.lerp(nextTransform, interpolator))
        }
    }
}


extension Transform {
    
    internal func lerp(_ a: Transform,
                       _ t: Double) -> Transform {
        
        .init(offset: offset.lerp(a.offset, t),
              rotation: rotation.slerp(a.rotation, t),
              scale: scale.lerp(a.scale, t))
    }
}
