//
//  Bone.swift
//
//  Created by Zack Brown on 10/11/2023.
//

import Euclid
import Foundation
import SceneKit

internal enum Bone: String,
                    CaseIterable,
                    Identifiable {
    
    case head,
         neck,
         leftClavicle = "Left Clavicle",
         rightClavicle = "Right Clavicle",
         leftArm = "Left Arm",
         rightArm = "Right Arm",
         leftForearm = "Left Forearm",
         rightForearm = "Right Forearm",
         leftHand = "Left Hand",
         rightHand = "Right Hand",
         spineUpper = "Spine Upper",
         spineLower = "Spine Lower",
         leftHipbone = "Left Hipbone",
         rightHipbone = "Right Hipbone",
         leftThigh = "Left Thigh",
         rightThigh = "Right Thigh",
         leftShin = "Left Shin",
         rightShin = "Right Shin",
         leftFoot = "Left Foot",
         rightFoot = "Right Foot"
    
    internal var id: String { rawValue.capitalized }
}

extension Bone {
    
    internal var start: Joint {
        
        switch self {
            
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
    
    internal var end: Joint {
        
        switch self {
            
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

extension Bone {
    
    internal enum Constant {
        
        static let height = 1.0
        static let ratio = 0.3333333333 // 1.0 / 3.0
    }
    
    internal var spring: Spring {
        
        switch self {
            
        case .head: return .init(0.07)
        case .neck: return .init(0.02)
        case .leftClavicle,
             .rightClavicle: return .init(0.07)
        case .leftArm,
             .rightArm: return .init(0.1)
        case .leftForearm,
             .rightForearm: return .init(0.1)
        case .leftHand,
                .rightHand: return .init(0.02)
        case .spineUpper: return .init(0.07)
        case .spineLower: return .init(0.03)
        case .leftHipbone,
             .rightHipbone: return .init(0.04)
        case .leftThigh,
                .rightThigh: return .init(0.1)
        case .leftShin,
                .rightShin: return .init(0.1)
        case .leftFoot,
                .rightFoot: return .init(0.02)
        }
    }
}

extension Bone {
    
    internal struct Influence {
        
        let indices: [UInt16]
        let weights: [Float]
    }
    
    /// SceneKit performs skeletal animation on the GPU only if the componentsPerVector count in this geometry source is 4 or less.
    /// https://developer.apple.com/documentation/scenekit/scnskinner/1522986-boneweights
    internal static let maximumBoneInfluenceContributions = 4
    
    internal static func influence(_ vector: Vector,
                                   _ bones: [SCNNode]) -> Influence {
        
        let distances = bones.reduce(into: [SCNNode : Double](), { result, bone in
            
            result[bone] = (Vector(bone.worldPosition) - vector).length
        })
        
        let sorted = distances.sorted { $0.value < $1.value }
        
        let nearest = sorted[0..<min(Self.maximumBoneInfluenceContributions, bones.count)]
        let total = nearest.reduce(into: Double()) { $0 += $1.value }
        let weight = 1.0 / total
        
        var indices: [UInt16] = []
        var weights: [Float] = []
        
        for (key, value) in nearest {
            
            guard let index = bones.firstIndex(of: key) else { continue }
            
            indices.append(UInt16(index))
            weights.append(Float(weight * value))
        }
            
        return .init(indices: indices,
                     weights: weights)
    }
}
