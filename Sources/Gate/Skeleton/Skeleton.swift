//
//  Skeleton.swift
//
//  Created by Zack Brown on 17/10/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

extension Skeleton {
    
    public enum Build: Int,
                       CaseIterable,
                       Identifiable {
        
        case small
        case medium
        case tall
        
        public var id: String {
            
            switch self {
                
            case .small: return "Small"
            case .medium: return "Medium"
            case .tall: return "Tall"
            }
        }
        
        internal var height: Double {
            
            switch self {
                
            case .small: return 0.3
            case .medium: return 0.35
            case .tall: return 0.4
            }
        }
        
        internal var radius: Double {
            
            switch self {
                
            case .small: return 0.03
            case .medium: return 0.04
            case .tall: return 0.05
            }
        }
        
        internal var limbRadius: Double { 0.01 }
    }
}

extension Skeleton.Build {
    
    internal enum Ratio: Int,
                         CaseIterable {
        
        case hair
        case face
        case shoulders
        case torso
        case hips
        case appendage //arms and legs are equal length
        
        internal var total: Int { Self.allCases.reduce(0) { $0 + $1.component } }
        
        internal var component: Int {
            
            switch self {
                
            case .hair: return 1
            case .face: return 2
            case .shoulders: return 1
            case .torso: return 2
            case .hips: return 1
            case .appendage: return 2
            }
        }
    }
    
    internal func length(ratio: Ratio) -> Double { (height / Double(ratio.total)) * Double(ratio.component) }
}

public class Skeleton: SCNNode {
    
    internal let hair = Hair()
    internal let face = Face()
    internal let torso = Torso()
    internal let hips = Hips()
    
    internal let leftShoulder = Limb(side: .left,
                                     appendage: .arm)
    internal let leftHip = Limb(side: .left,
                                appendage: .leg)
    
    internal let rightShoulder = Limb(side: .right,
                                      appendage: .arm)
    internal let rightHip = Limb(side: .right,
                                 appendage: .leg)
    
    internal let build: Build
    
    public init(build: Build) {
        
        self.build = build
        
        super.init()
        
        self.name = "Root"
        
        addChildNode(hips)
        
        hips.addChildNode(torso)
        hips.addChildNode(leftHip)
        hips.addChildNode(rightHip)
        
        torso.addChildNode(face)
        torso.addChildNode(leftShoulder)
        torso.addChildNode(rightShoulder)
        
        face.addChildNode(hair)
        
        bindPose(build: build)
        
        let mesh = mesh(build: build)
        
        self.geometry = SCNGeometry(mesh)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Skeleton {
 
    internal var bones: [SCNNode] { [self] + recursiveChildren }
    internal var inverseBindTransforms: [NSValue] { bones.map { NSValue(scnMatrix4: $0.transform) } }
}

extension Skeleton {
    
    internal func bindPose(build: Build) {
        
        position = SCNVector3(0.0, 0.0, 0.0)
        
        hair.bindPose(build: build)
        face.bindPose(build: build)
        torso.bindPose(build: build)
        hips.bindPose(build: build)
        leftShoulder.bindPose(build: build)
        rightShoulder.bindPose(build: build)
        leftHip.bindPose(build: build)
        rightHip.bindPose(build: build)
    }
}

extension Skeleton {
    
    internal func mesh(build: Build) -> Mesh {
        
        do {
            
            return Mesh(submeshes: [try hair.mesh(build: build,
                                                  color: .yellow),
                                    try face.mesh(build: build,
                                                  color: .magenta),
                                    try torso.mesh(build: build,
                                                   color: .blue),
                                    try hips.mesh(build: build,
                                                  color: .orange),
                                    try leftShoulder.mesh(build: build,
                                                          color: .red),
                                    try rightShoulder.mesh(build: build,
                                                           color: .red),
                                    try leftHip.mesh(build: build,
                                                     color: .blue),
                                    try rightHip.mesh(build: build,
                                                      color: .blue)])
        }
        catch {
            
            fatalError(error.localizedDescription)
        }
    }
}
