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
    
    internal let joints: [SCNNode]
    
    internal var rootNode: Joint { .hipEffector }
    
    internal var boneStructure: [Bone] { Bone.allCases }
    internal var controlPoints: [Joint] { Joint.allCases }
    
    internal var effectors: [Joint] { Joint.effectors }
    
    internal var inverseBindTransforms: [NSValue] { joints.map { NSValue(scnMatrix4: SCNMatrix4Invert($0.worldTransform)) } }

    internal lazy var tPose: [Joint : Transform] = {
        // hips, spine, neck and head
        [.hipEffector : .offset(Vector.unitY * (Bone.leftShin.maximumLength +
                                             Bone.leftThigh.maximumLength)),
         .chest : .offset(Vector.unitY * Bone.spineLower.maximumLength),
         .collarbone : .offset(Vector.unitY * Bone.spineUpper.maximumLength),
         .neckEffector : .offset(Vector.unitY * Bone.neck.maximumLength),
         .headEffector : .offset(Vector.unitY * Bone.head.maximumLength),

         //left arm
         .leftShoulder : .offset(Vector.unitX * Bone.leftClavicle.maximumLength),
         .leftElbow : .offset(Vector.unitX * Bone.leftArm.maximumLength),
         .leftWrist : .offset(Vector.unitX * Bone.leftForearm.maximumLength),
         .leftHandEffector : .offset(Vector.unitX * Bone.leftHand.maximumLength),

         //right arm
         .rightShoulder : Transform(offset: -Vector.unitX * Bone.rightClavicle.maximumLength,
                                    rotation: .yaw(.radians(.pi))),
         .rightElbow : .offset(Vector.unitX * Bone.rightArm.maximumLength),
         .rightWrist : .offset(Vector.unitX * Bone.rightForearm.maximumLength),
         .rightHandEffector : .offset(Vector.unitX * Bone.rightHand.maximumLength),

         //left leg
         .leftHip : .offset(Vector.unitX * Bone.leftHipbone.maximumLength),
         .leftKnee : .offset(-Vector.unitY * Bone.leftThigh.maximumLength),
         .leftHeel : .offset(-Vector.unitY * Bone.leftShin.maximumLength),
         .leftMidfoot: .offset(Vector.unitZ * Bone.leftHindfoot.maximumLength),
         .leftFootEffector : .offset(Vector.unitZ * Bone.leftForefoot.maximumLength),

         //right leg
         .rightHip : .offset(-Vector.unitX * Bone.rightHipbone.maximumLength),
         .rightKnee : .offset(-Vector.unitY * Bone.rightThigh.maximumLength),
         .rightHeel : .offset(-Vector.unitY * Bone.rightShin.maximumLength),
         .rightMidfoot : .offset(Vector.unitZ * Bone.rightHindfoot.maximumLength),
         .rightFootEffector : .offset(Vector.unitZ * Bone.rightForefoot.maximumLength)]
    }()
    
    internal required override init() {
        
        self.joints = Joint.allCases.map { SCNNode($0.id) }
        
        super.init()
        
        bind()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Skeleton {
    
    internal func joint(_ joint: Joint) -> SCNNode? { joints.first { $0.name == joint.id } }
    
    internal func position(_ joint: Joint) -> Vector {
        
        guard let node = self.joint(joint) else { return .zero }
        
        return Vector(node.worldPosition)
    }
}

extension Skeleton {
    
    private func bind() {
        
        let pose = tPose
        
        for bone in boneStructure {
            
            let start = bone.start
            let end = bone.end
            
            guard let startNode = joint(start),
                  let endNode = joint(end) else { fatalError("Missing skeleton joint for bone: \(bone.id)") }
            
            let constraint = SCNDistanceConstraint(target: startNode)
            
            constraint.minimumDistance = bone.minimumLength
            constraint.maximumDistance = bone.maximumLength
            
            endNode.addConstraint(constraint)
            endNode.transform = SCNMatrix4(pose[end] ?? .identity)
            
            startNode.addChildNode(endNode)

            guard startNode.parent == nil else { continue }

            startNode.transform = SCNMatrix4(pose[start] ?? .identity)
            
            addChildNode(startNode)
        }
        
        for joint in joints {
            
            var mesh = Mesh([])
            
            for child in joint.childNodes {
                
                guard let lineSegment = LineSegment(start: .zero,
                                                    end: Vector(child.position)),
                      let bone = try? Mesh.bone(line: lineSegment,
                                                color: .black) else { continue }
                
                let socket = Mesh.cube(center: .zero,
                                       size: Vector(size: 0.01),
                                       material: Color.red)
                
                mesh = mesh.merge(bone.merge(socket))
            }
            
            joint.addChildNode(SCNNode(mesh: mesh))
        }
    }
}
