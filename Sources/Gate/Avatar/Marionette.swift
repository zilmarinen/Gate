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
    
    internal var leftHand = SCNNode(geometry: SCNGeometry(Mesh.cube(size: Vector(size: 0.01),
                                                                    material: Color.red)))
    internal var rightHand = SCNNode(geometry: SCNGeometry(Mesh.cube(size: Vector(size: 0.01),
                                                                     material: Color.green)))
    
    internal var leftFoot = SCNNode(geometry: SCNGeometry(Mesh.cube(size: Vector(size: 0.01),
                                                                    material: Color.blue)))
    internal var rightFoot = SCNNode(geometry: SCNGeometry(Mesh.cube(size: Vector(size: 0.01),
                                                                     material: Color.yellow)))
    
    internal var leftFootRest = Vector.zero
    internal var rightFootRest = Vector.zero
    
    internal let leftFootConstraint: SCNIKConstraint
    internal let leftKneeConstraint: SCNIKConstraint
    
    internal let rightFootConstraint: SCNIKConstraint
    internal let rightKneeConstraint: SCNIKConstraint
    
    internal let skeleton: Skeleton
    
    required init(skeleton: Skeleton) {
        
        self.skeleton = skeleton
        
        self.leftFootRest = Vector(skeleton.leftHip.extremity.worldPosition)
        self.rightFootRest = Vector(skeleton.rightHip.extremity.worldPosition)
        
        self.leftFootConstraint = SCNIKConstraint(chainRootNode: skeleton.hips)
        self.rightFootConstraint = SCNIKConstraint(chainRootNode: skeleton.hips)
        
        self.leftKneeConstraint = SCNIKConstraint(chainRootNode: skeleton.leftHip)
        self.rightKneeConstraint = SCNIKConstraint(chainRootNode: skeleton.rightHip)
        
        super.init()
        
        addChildNode(skeleton)
        addChildNode(leftHand)
        addChildNode(rightHand)
        addChildNode(leftFoot)
        addChildNode(rightFoot)
   
        skeleton.leftHip.extremity.constraints = [self.leftFootConstraint]
        skeleton.rightHip.extremity.constraints = [self.rightFootConstraint]
        
        skeleton.leftHip.joint.constraints = [self.leftKneeConstraint]
        skeleton.rightHip.joint.constraints = [self.rightKneeConstraint]
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Marionette {
    
    func update(delta: TimeInterval,
                time: TimeInterval) {
        
        let frequency = 2.0
        
        let strideWidth = (skeleton.height.legLength / 2.0)
        let stepHeight = strideWidth / 2.0

        let s = abs(sin(time * frequency))
        let si = (1.0 - s)
        
        let t = abs(sin(time * (frequency * 2.0)))
        let ti = (1.0 - t)
        
        
        leftFoot.position = SCNVector3(leftFootRest + Vector(0.0, t * stepHeight, s * -strideWidth))
        rightFoot.position = SCNVector3(rightFootRest + Vector(0.0, t * stepHeight, si * -strideWidth))
        
        self.leftFootConstraint.targetPosition = leftFoot.position
        self.rightFootConstraint.targetPosition = rightFoot.position
    }
}
