//
//  Hair.swift
//
//  Created by Zack Brown on 21/10/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

extension Skeleton {
    
    internal class Hair: SCNNode {
        
        public override init() {
            
            super.init()
            
            self.name = "Hair"
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    }
}

extension Skeleton.Hair {
    
    internal func bindPose(build: Skeleton.Build) { position = SCNVector3(0.0, build.length(ratio: .hair), 0.0) }
}

extension Skeleton.Hair {
    
    internal func mesh(build: Skeleton.Build,
                       color: Color) throws -> Mesh {
        
        guard let line = LineSegment(start: Vector(worldPosition),
                                     end: Vector(worldPosition) - Vector(0.0, build.length(ratio: .hair), 0.0)) else { throw MeshError.invalidLineSegment }
        
        return try Mesh.cap(line: line,
                            radius: build.radius,
                            color: color)
    }
}

