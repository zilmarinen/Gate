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
    
    internal enum Height: String,
                          CaseIterable,
                          Identifiable {
        
        case short
        case medium
        case tall
        
        internal var id: String { rawValue.capitalized }
        
        internal var scale: Double {
            
            switch self {
                
            case .short: return 0.9
            case .medium: return 1.0
            case .tall: return 1.1
            }
        }
    }
    
    internal let height: Height
    internal let joints: [SCNNode]
    
    internal var rootNode: Joint { .hipEffector }
    
    internal var boneStructure: [Bone] { Bone.allCases }
    internal var controlPoints: [Joint] { Joint.allCases }
    
    internal var effectors: [Joint] { Joint.effectors }
    
    internal var inverseBindTransforms: [NSValue] { joints.map { NSValue(scnMatrix4: SCNMatrix4Invert($0.worldTransform)) } }

    internal lazy var tPose: [Joint : Transform] = {
        // hips, spine, neck and head
        [.hipEffector : .offset(Vector.up * (spring(.leftShin).maximumLength +
                                             spring(.leftThigh).maximumLength)),
         .chest : .offset(Vector.up * spring(.spineLower).maximumLength),
         .collarbone : .offset(Vector.up * spring(.spineUpper).maximumLength),
         .neckEffector : .offset(Vector.up * spring(.neck).maximumLength),
         .headEffector : .offset(Vector.up * spring(.head).maximumLength),

         //left arm
         .leftShoulder : Transform(offset: -Vector.right * spring(.leftClavicle).maximumLength,
                                   rotation: .yaw(.radians(.pi))),
         .leftElbow : .offset(Vector.right * spring(.leftArm).maximumLength),
         .leftWrist : .offset(Vector.right * spring(.leftForearm).maximumLength),
         .leftHandEffector : .offset(Vector.right * spring(.leftHand).maximumLength),

         //right arm
         .rightShoulder : .offset(Vector.right * spring(.rightClavicle).maximumLength),
         .rightElbow : .offset(Vector.right * spring(.rightArm).maximumLength),
         .rightWrist : .offset(Vector.right * spring(.rightForearm).maximumLength),
         .rightHandEffector : .offset(Vector.right * spring(.rightHand).maximumLength),

         //left leg
         .leftHip : .offset(-Vector.right * spring(.leftHipbone).maximumLength),
         .leftKnee : .offset(-Vector.up * spring(.leftThigh).maximumLength),
         .leftHeel : .offset(-Vector.up * spring(.leftShin).maximumLength),
         .leftFootEffector : .offset(Vector.forward * spring(.leftFoot).maximumLength),

         //right leg
         .rightHip : .offset(Vector.right * spring(.rightHipbone).maximumLength),
         .rightKnee : .offset(-Vector.up * spring(.rightThigh).maximumLength),
         .rightHeel : .offset(-Vector.up * spring(.rightShin).maximumLength),
         .rightFootEffector : .offset(Vector.forward * spring(.rightFoot).maximumLength)]
    }()
    
    internal required init(_ height: Height) {
        
        self.height = height
        self.joints = Joint.allCases.map { SCNNode($0.id) }
        
        super.init()
        
        bind()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Skeleton {
    
    internal func joint(_ joint: Joint) -> SCNNode? { joints.first { $0.name == joint.id } }
    
    internal func spring(_ bone: Bone) -> Spring {
        
        switch bone {
            
        case .head: return .init(0.07 * height.scale)
        case .neck: return .init(0.02 * height.scale)
        case .leftClavicle,
             .rightClavicle: return .init(0.07 * height.scale)
        case .leftArm,
             .rightArm: return .init(0.1 * height.scale)
        case .leftForearm,
             .rightForearm: return .init(0.1 * height.scale)
        case .leftHand,
                .rightHand: return .init(0.02 * height.scale)
        case .spineUpper: return .init(0.07 * height.scale)
        case .spineLower: return .init(0.03 * height.scale)
        case .leftHipbone,
             .rightHipbone: return .init(0.04 * height.scale)
        case .leftThigh,
                .rightThigh: return .init(0.1 * height.scale)
        case .leftShin,
                .rightShin: return .init(0.1 * height.scale)
        case .leftFoot,
                .rightFoot: return .init(0.02 * height.scale)
        }
    }
}

extension Skeleton {
    
    private func bind() {
        
        let pose = tPose
        
        for bone in boneStructure {
            
            let start = bone.start
            let end = bone.end
            let spring = spring(bone)
            
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
