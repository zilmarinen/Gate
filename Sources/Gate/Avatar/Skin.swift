//
//  Skin.swift
//
//  Created by Zack Brown on 07/08/2024.
//

import Bivouac
import Euclid
import Foundation

internal class Skin {
    
    internal let skeleton: Skeleton
    
    required init(_ skeleton: Skeleton) {
        
        self.skeleton = skeleton
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Skin {
    
    internal var mesh: Mesh {
        
        guard let leftFoot = skeleton.childNode(.leftHeel),
              let rightFoot = skeleton.childNode(.rightHeel) else { return Mesh([]) }
        
        let head = Mesh.head()
        let torso = Mesh.torso()
        let pelvis = Mesh.pelvis()
        let leftArm = Mesh.arm()
        let rightArm = Mesh.arm()
        let leftLeg = Mesh.leg(0.2).translated(by: Vector(leftFoot.worldPosition))
        let rightLeg = Mesh.leg(0.2).translated(by: Vector(rightFoot.worldPosition))
        
        return head.merge(
               torso.merge(
               pelvis.merge(
               leftArm.merge(
               rightArm.merge(
               leftLeg.merge(
               rightLeg))))))
    }
}
