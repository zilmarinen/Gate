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
    
    internal class Torso: SCNNode {
        
        public override init() {
            
            super.init()
            
            self.name = "Torso"
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    }
}

extension Skeleton.Torso {
    
    internal func bindPose(build: Skeleton.Build) { position = SCNVector3(0.0, build.length(ratio: .torso), 0.0) }
}

extension Skeleton.Torso {
    
    internal func mesh(build: Skeleton.Build,
                       color: Color) throws -> Mesh {
        
        guard let line = LineSegment(start: Vector(worldPosition) - Vector(0.0, build.length(ratio: .torso), 0.0),
                                     end: Vector(worldPosition)) else { throw MeshError.invalidLineSegment }
        
        return try Mesh.cylinder(line: line,
                                 radius: build.radius,
                                 color: color)
    }
}
