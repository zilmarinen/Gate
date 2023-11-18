//
//  Humanoid.swift
//
//  Created by Zack Brown on 11/11/2023.
//

import Euclid
import Foundation
import SceneKit

extension Endoskeleton {
    
    public class Humanoid: SCNNode,
                           Skeleton {
        
        public var rootNode: Joint { .hipEffector }
        
        public var boneStructure: [Bone] { Bone.allCases }
        
        public var joints: [Joint] { Joint.allCases }
        
        public var effectors: [Joint] { [.headEffector,
                                         .neckEffector,
                                         .hipEffector,
                                         .leftHandEffector,
                                         .rightHandEffector,
                                         .leftFootEffector,
                                         .rightFootEffector] }
        
        public lazy var tPose: [Joint : Transform] = {
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
        }()
    }
}

extension Endoskeleton.Humanoid {
    
    public enum Bone: String,
                      SkeletonBone {
        
        case head,
             neck,
             leftClavicle,
             rightClavicle,
             leftArm,
             rightArm,
             leftForearm,
             rightForearm,
             leftHand,
             rightHand,
             spineUpper,
             spineLower,
             leftHipbone,
             rightHipbone,
             leftThigh,
             rightThigh,
             leftShin,
             rightShin,
             leftFoot,
             rightFoot
        
        public var id: String { rawValue }
    }
    
    public func spring(for bone: Bone) -> Spring {
        
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
}

extension Endoskeleton.Humanoid {
    
    public enum Joint: String,
                       SkeletonJoint {
        
        case headEffector,
             neckEffector,
             hipEffector,
             leftHandEffector,
             rightHandEffector,
             leftFootEffector,
             rightFootEffector
        
        case collarbone,
            leftShoulder,
            rightShoulder,
            leftElbow,
            rightElbow,
            leftWrist,
            rightWrist,
            chest,
            leftHip,
            rightHip,
            leftKnee,
            rightKnee,
            leftHeel,
            rightHeel
        
        public var id: String { rawValue }
    }
    
    public func startJoint(for bone: Bone) -> Joint {
        
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
    
    public func endJoint(for bone: Bone) -> Joint {
        
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
