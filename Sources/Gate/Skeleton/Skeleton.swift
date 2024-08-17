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
        [.hipEffector : .offset(Vector.up * (Bone.leftShin.spring.maximumLength +
                                             Bone.leftThigh.spring.maximumLength)),
         .chest : .offset(Vector.up * Bone.spineLower.spring.maximumLength),
         .collarbone : .offset(Vector.up * Bone.spineUpper.spring.maximumLength),
         .neckEffector : .offset(Vector.up * Bone.neck.spring.maximumLength),
         .headEffector : .offset(Vector.up * Bone.head.spring.maximumLength),

         //left arm
         .leftShoulder : Transform(offset: -Vector.right * Bone.leftClavicle.spring.maximumLength,
                                   rotation: .yaw(.radians(.pi))),
         .leftElbow : .offset(Vector.right * Bone.leftArm.spring.maximumLength),
         .leftWrist : .offset(Vector.right * Bone.leftForearm.spring.maximumLength),
         .leftHandEffector : .offset(Vector.right * Bone.leftHand.spring.maximumLength),

         //right arm
         .rightShoulder : .offset(Vector.right * Bone.rightClavicle.spring.maximumLength),
         .rightElbow : .offset(Vector.right * Bone.rightArm.spring.maximumLength),
         .rightWrist : .offset(Vector.right * Bone.rightForearm.spring.maximumLength),
         .rightHandEffector : .offset(Vector.right * Bone.rightHand.spring.maximumLength),

         //left leg
         .leftHip : .offset(-Vector.right * Bone.leftHipbone.spring.maximumLength),
         .leftKnee : .offset(-Vector.up * Bone.leftThigh.spring.maximumLength),
         .leftHeel : .offset(-Vector.up * Bone.leftShin.spring.maximumLength),
         .leftFootEffector : .offset(Vector.forward * Bone.leftFoot.spring.maximumLength),

         //right leg
         .rightHip : .offset(Vector.right * Bone.rightHipbone.spring.maximumLength),
         .rightKnee : .offset(-Vector.up * Bone.rightThigh.spring.maximumLength),
         .rightHeel : .offset(-Vector.up * Bone.rightShin.spring.maximumLength),
         .rightFootEffector : .offset(Vector.forward * Bone.rightFoot.spring.maximumLength)]
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
}

extension Skeleton {
    
    private func bind() {
        
        let pose = tPose
        
        for bone in boneStructure {
            
            let start = bone.start
            let end = bone.end
            let spring = bone.spring
            
            guard let startNode = joint(start),
                  let endNode = joint(end) else { fatalError("Missing skeleton joint for bone: \(bone.id)") }
            
            let constraint = SCNDistanceConstraint(target: startNode)
            
            constraint.minimumDistance = spring.minimumLength
            constraint.maximumDistance = spring.maximumLength
            
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
