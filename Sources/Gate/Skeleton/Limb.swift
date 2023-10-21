//
//  Limb.swift
//
//  Created by Zack Brown on 19/10/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

extension Skeleton {
    
    internal class Limb: SCNNode {
        
        internal enum Side: String,
                            Identifiable {
            
            case left
            case right
            
            var id: String { rawValue.capitalized }
        }
        
        internal enum Appendage: String,
                                 Identifiable {
            
            case arm
            case leg
            
            var id: String { rawValue.capitalized }
        }
        
        internal let joint = SCNNode()
        internal let extremity = SCNNode()
        internal let ik = SCNNode()
        
        internal let side: Side
        internal let appendage: Appendage
        
        public init(side: Side,
                    appendage: Appendage) {
            
            self.side = side
            self.appendage = appendage
            
            super.init()
            
            self.name = "\(side.id) \(appendage.id)"
            joint.name = "\(side.id) " + (appendage == .arm ? "Elbow" : "Knee")
            extremity.name = "\(side.id) " + (appendage == .arm ? "Hand" : "Foot")
            ik.name = (extremity.name ?? "") + " IK"
            
            addChildNode(joint)
            
            joint.addChildNode(extremity)
            
            extremity.addChildNode(ik)
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    }
}

extension Skeleton.Limb {
    
    internal func bindPose(build: Skeleton.Build) {
        
        let component = side == .left ? -1.0 : 1.0
        let limbLength = build.length(ratio: .appendage) / 2.0
        let ikLength = limbLength / 2.0
        
        switch appendage {
            
        case .arm:
            
            self.position = SCNVector3(build.radius * component, -build.length(ratio: .shoulders), 0.0)
            joint.position = SCNVector3(limbLength * component, 0.0, 0.0)
            extremity.position = SCNVector3(limbLength * component, 0.0, 0.0)
            ik.position = SCNVector3(ikLength * component, 0.0, 0.0)
            
        case .leg:
            
            self.position = SCNVector3((build.radius / 2.0) * component, -build.length(ratio: .hips), 0.0)
            joint.position = SCNVector3(0.0, -limbLength, 0.0)
            extremity.position = SCNVector3(0.0, -limbLength, 0.0)
            ik.position = SCNVector3(0.0, 0.0, ikLength)
        }
    }
}

extension Skeleton.Limb {
    
    internal func mesh(build: Skeleton.Build,
                       color: Color) throws -> Mesh {
        
        guard let line = LineSegment(start: Vector(extremity.worldPosition),
                                     end: Vector(worldPosition)) else { throw MeshError.invalidLineSegment }
        
        return try Mesh.cap(line: line,
                            radius: build.limbRadius,
                            color: color)
    }
}
