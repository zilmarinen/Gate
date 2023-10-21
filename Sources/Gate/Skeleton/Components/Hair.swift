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
    
    internal class Hair: SCNNode,
                         Bindable,
                         Meshable {
        
        public override init() {
            
            super.init()
            
            self.name = "Hair"
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    }
}

extension Skeleton.Hair {
    
    internal func bindPose(height: Skeleton.Height,
                           shape: Skeleton.Shape) { position = SCNVector3(0.0, height.hairHeight, 0.0) }
}

extension Skeleton.Hair {
    
    internal func mesh(height: Skeleton.Height,
                       shape: Skeleton.Shape,
                       color: Color) throws -> Mesh {
        
        guard let line = LineSegment(start: Vector(worldPosition),
                                     end: Vector(worldPosition) - Vector(0.0, height.hairHeight, 0.0)) else { throw MeshError.invalidLineSegment }
        
        return try Mesh.cap(line: line,
                            radius: shape.upperRadius,
                            color: .blue)
    }
}

