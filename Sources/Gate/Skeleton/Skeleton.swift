//
//  Skeleton.swift
//
//  Created by Zack Brown on 17/10/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

internal class Skeleton: SCNNode {
    
    internal var rootNode: Joint { .hipEffector }
    
    internal var boneStructure: [Bone] { Bone.allCases }
    
    internal var effectors: [Joint] { [.headEffector,
                                       .neckEffector,
                                       .hipEffector,
                                       .leftHandEffector,
                                       .rightHandEffector,
                                       .leftFootEffector,
                                       .rightFootEffector] }
    
    internal var joints: [Joint] { Joint.allCases }
    
    internal var bones: [SCNNode] { recursiveChildren }
    internal var inverseBindTransforms: [NSValue] { bones.map { NSValue(scnMatrix4: SCNMatrix4Invert($0.worldTransform)) } }
    
    internal var tPose: [Joint : Transform] {
        // hips, spine, neck and head
        [.hipEffector : .offset(Vector.up * (spring(for: .leftShin).maximumLength +
                                             spring(for: .leftThigh).maximumLength)),
         .chest : .offset(Vector.up * spring(for: .spineLower).maximumLength),
         .collarbone : .offset(Vector.up * spring(for: .spineUpper).maximumLength),
         .neckEffector : .offset(Vector.up * spring(for: .neck).maximumLength),
         .headEffector : .offset(Vector.up * spring(for: .head).maximumLength),

         //left arm
         .leftShoulder : Transform(offset: -Vector.right * spring(for: .leftClavicle).maximumLength,
                                   rotation: .yaw(.radians(.pi))),
         .leftElbow : .offset(Vector.right * spring(for: .leftArm).maximumLength),
         .leftWrist : .offset(Vector.right * spring(for: .leftForearm).maximumLength),
         .leftHandEffector : .offset(Vector.right * spring(for: .leftHand).maximumLength),

         //right arm
         .rightShoulder : .offset(Vector.right * spring(for: .rightClavicle).maximumLength),
         .rightElbow : .offset(Vector.right * spring(for: .rightArm).maximumLength),
         .rightWrist : .offset(Vector.right * spring(for: .rightForearm).maximumLength),
         .rightHandEffector : .offset(Vector.right * spring(for: .rightHand).maximumLength),

         //left leg
         .leftHip : .offset(-Vector.right * spring(for: .leftHipbone).maximumLength),
         .leftKnee : .offset(-Vector.up * spring(for: .leftThigh).maximumLength),
         .leftHeel : .offset(-Vector.up * spring(for: .leftShin).maximumLength),
         .leftFootEffector : .offset(Vector.forward * spring(for: .leftFoot).maximumLength),

         //right leg
         .rightHip : .offset(Vector.right * spring(for: .rightHipbone).maximumLength),
         .rightKnee : .offset(-Vector.up * spring(for: .rightThigh).maximumLength),
         .rightHeel : .offset(-Vector.up * spring(for: .rightShin).maximumLength),
         .rightFootEffector : .offset(Vector.forward * spring(for: .rightFoot).maximumLength)]
    }
}

extension Skeleton {
    
    internal func childNode(_ joint: Joint) -> SCNNode? { childNode(withName: joint.id,
                                                                    recursively: true) }
    
    internal func spring(for bone: Bone) -> Spring {

        switch bone {

        case .head: return Spring(0.1)
        case .neck: return Spring(0.02)
        case .leftClavicle,
             .rightClavicle: return Spring(0.07)
        case .leftArm,
             .rightArm: return Spring(0.1)
        case .leftForearm,
             .rightForearm: return Spring(0.1)
        case .leftHand,
             .rightHand: return Spring(0.02)
        case .spineUpper: return Spring(0.14)
        case .spineLower: return Spring(0.14)
        case .leftHipbone,
             .rightHipbone: return Spring(0.04)
        case .leftThigh,
             .rightThigh: return Spring(0.1)
        case .leftShin,
             .rightShin: return Spring(0.1)
        case .leftFoot,
             .rightFoot: return Spring(0.02)
        }
    }
    
    internal func startJoint(for bone: Bone) -> Joint {

        switch bone {

        case .head: return .neckEffector
        case .neck: return .collarbone
        case .leftClavicle: return .collarbone
        case .rightClavicle: return .collarbone
        case .leftArm: return .leftShoulder
        case .rightArm: return .rightShoulder
        case .leftForearm: return .leftElbow
        case .rightForearm: return .rightElbow
        case .leftHand: return .leftWrist
        case .rightHand: return .rightWrist
        case .spineUpper: return .chest
        case .spineLower: return .hipEffector
        case .leftHipbone: return .hipEffector
        case .rightHipbone: return .hipEffector
        case .leftThigh: return .leftHip
        case .rightThigh: return .rightHip
        case .leftShin: return .leftKnee
        case .rightShin: return .rightKnee
        case .leftFoot: return .leftHeel
        case .rightFoot: return .rightHeel
        }
    }

    internal func endJoint(for bone: Bone) -> Joint {

        switch bone {

        case .head: return .headEffector
        case .neck: return .neckEffector
        case .leftClavicle: return .leftShoulder
        case .rightClavicle: return .rightShoulder
        case .leftArm: return .leftElbow
        case .rightArm: return .rightElbow
        case .leftForearm: return .leftWrist
        case .rightForearm: return .rightWrist
        case .leftHand: return .leftHandEffector
        case .rightHand: return .rightHandEffector
        case .spineUpper: return .collarbone
        case .spineLower: return .chest
        case .leftHipbone: return .leftHip
        case .rightHipbone: return .rightHip
        case .leftThigh: return .leftKnee
        case .rightThigh: return .rightKnee
        case .leftShin: return .leftHeel
        case .rightShin: return .rightHeel
        case .leftFoot: return .leftFootEffector
        case .rightFoot: return .rightFootEffector
        }
    }
}

extension Skeleton {
    
    internal func bind() {

        for bone in boneStructure {
            
            let start = startJoint(for: bone)
            let end = endJoint(for: bone)
            let spring = spring(for: bone)
            
            let startNode = childNode(start) ?? SCNNode(start.id)
            let endNode = childNode(end) ?? SCNNode(end.id)
            
            let constraint = SCNDistanceConstraint(target: startNode)
            
            constraint.minimumDistance = spring.minimumLength
            constraint.maximumDistance = spring.maximumLength
            
            endNode.addConstraint(constraint)
            endNode.transform = SCNMatrix4(tPose[end] ?? .identity)
            
            startNode.addChildNode(endNode)

            guard startNode.parent == nil else { continue }

            startNode.transform = SCNMatrix4(tPose[start] ?? .identity)
            
            addChildNode(startNode)
        }
        
        for joint in joints {
            
            guard let node = childNode(joint) else { continue }
            
            var mesh = Mesh([])
            
//            for child in node.childNodes {
//                
//                guard let bone = try? Mesh.bone(start: .zero,
//                                                end: Vector(child.position),
//                                                color: .black) else { continue }
//                
//                mesh = mesh.merge(bone)
//            }
            
            let child = SCNNode()
            
            child.geometry = SCNGeometry(mesh)
            
            node.addChildNode(child)
        }
    }
}
