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
        
        do {
            
            guard let leftFoot = skeleton.joint(.leftHeel),
                  let rightFoot = skeleton.joint(.rightHeel),
                  let hip = skeleton.joint(.hipEffector),
                  let chest = skeleton.joint(.chest),
                  let neck = skeleton.joint(.neckEffector) else { throw MeshError.invalidPolygon }
            
            let legLength = Bone.leftShin.spring.maximumLength + Bone.leftThigh.spring.maximumLength
            let torsoHeight = Bone.spineUpper.spring.maximumLength + Bone.neck.spring.maximumLength
            let pelvisHeight = Bone.spineLower.spring.maximumLength
            
            let head = try Mesh.head().translated(by: Vector(neck.worldPosition))
            let torso = Mesh.torso(torsoHeight).translated(by: Vector(chest.worldPosition))
            let pelvis = Mesh.pelvis(pelvisHeight).translated(by: Vector(hip.worldPosition))
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
        catch { fatalError(error.localizedDescription) }
    }
}
