//
//  Torso.swift
//
//  Created by Zack Brown on 21/10/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

extension Skeleton {
    
    internal class Torso: SCNNode,
                          Bindable,
                          Meshable {
        
        public override init() {
            
            super.init()
            
            self.name = "Torso"
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    }
}

extension Skeleton.Torso {
    
    internal func bindPose(height: Skeleton.Height,
                           shape: Skeleton.Shape) { position = SCNVector3(0.0, height.torsoHeight, 0.0) }
}

extension Skeleton.Torso {
    
    internal func mesh(height: Skeleton.Height,
                       shape: Skeleton.Shape,
                       color: Color) throws -> Mesh {
        
        guard let line = LineSegment(start: Vector(worldPosition) - Vector(0.0, height.torsoHeight, 0.0),
                                     end: Vector(worldPosition)) else { throw MeshError.invalidLineSegment }
        
        return try Mesh.cylinder(line: line,
                                 radius: shape.upperRadius,
                                 color: .orange)
    }
}
