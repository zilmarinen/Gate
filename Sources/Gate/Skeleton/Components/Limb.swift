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
    
    internal class Limb: SCNNode,
                         Bindable,
                         Meshable {
        
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
    
    internal func bindPose(height: Skeleton.Height,
                           shape: Skeleton.Shape) {
        
        let component = side == .left ? -1.0 : 1.0
        let limbLength = (appendage == .arm ? height.armLength : height.legLength) / 2.0
        let ikLength = limbLength / 2.0
        
        switch appendage {
            
        case .arm:
            
            self.position = SCNVector3(shape.upperRadius * component, -height.torsoHeight / 2.0, 0.0)
            joint.position = SCNVector3(limbLength * component, 0.0, 0.0)
            extremity.position = SCNVector3(limbLength * component, 0.0, 0.0)
            ik.position = SCNVector3(ikLength * component, 0.0, 0.0)
            
        case .leg:
            
            self.position = SCNVector3((shape.upperRadius / 2.0) * component, -height.hipHeight, 0.0)
            joint.position = SCNVector3(0.0, -limbLength, 0.0)
            extremity.position = SCNVector3(0.0, -limbLength, 0.0)
            ik.position = SCNVector3(0.0, 0.0, ikLength)
        }
    }
}

extension Skeleton.Limb {
    
    internal func mesh(height: Skeleton.Height,
                       shape: Skeleton.Shape,
                       color: Color) throws -> Mesh {
        
        guard let limb = LineSegment(start: Vector(extremity.worldPosition),
                                     end: Vector(worldPosition)) else { throw MeshError.invalidLineSegment }
        
        guard appendage == .arm,
              let hand = LineSegment(start: Vector(ik.worldPosition),
                                     end: Vector(extremity.worldPosition)) else {
            
            return try Mesh.cap(line: limb,
                                radius: shape.limbRadius,
                                color: color)
        }
        
        let arm = try Mesh.cylinder(line: limb,
                                    radius: shape.limbRadius,
                                    color: color)
        
        let manus = try Mesh.cap(line: hand,
                                 radius: shape.limbRadius,
                                 color: .orange)
        
        return arm.union(manus)
    }
}
