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
        
        guard let leftFoot = skeleton.joint(.leftHeel),
              let rightFoot = skeleton.joint(.rightHeel),
              let hip = skeleton.joint(.hipEffector),
              let chest = skeleton.joint(.chest) else { return Mesh([]) }
        
        let legLength = skeleton.spring(.leftShin).maximumLength + skeleton.spring(.leftThigh).maximumLength
        let torsoHeight = skeleton.spring(.spineUpper).maximumLength + skeleton.spring(.neck).maximumLength
        
        let head = Mesh.head()
        let torso = Mesh.torso(torsoHeight).translated(by: Vector(chest.worldPosition))
        let pelvis = Mesh.pelvis(skeleton.spring(.spineLower).maximumLength).translated(by: Vector(hip.worldPosition))
        let leftArm = Mesh.arm(0.2)
        let rightArm = Mesh.arm(0.2)
        let leftLeg = Mesh.leg(legLength).translated(by: Vector(leftFoot.worldPosition))
        let rightLeg = Mesh.leg(legLength).translated(by: Vector(rightFoot.worldPosition))
        
        return head.merge(
               torso.merge(
               pelvis.merge(
               leftArm.merge(
               rightArm.merge(
               leftLeg.merge(
               rightLeg))))))
    }
}
