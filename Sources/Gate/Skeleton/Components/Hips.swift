//
//  Hips.swift
//
//  Created by Zack Brown on 21/10/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

extension Skeleton {
    
    internal class Hips: SCNNode,
                         Bindable,
                         Meshable {
        
        public override init() {
            
            super.init()
            
            self.name = "Hips"
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    }
}

extension Skeleton.Hips {
    
    internal func bindPose(height: Skeleton.Height,
                           shape: Skeleton.Shape) { position = SCNVector3(0.0, height.legLength + height.hipHeight, 0.0) }
}

extension Skeleton.Hips {
    
    internal func mesh(height: Skeleton.Height,
                       shape: Skeleton.Shape,
                       color: Color) throws -> Mesh {
        
        guard let line = LineSegment(Vector(worldPosition) - Vector(0.0, height.hipHeight, 0.0),
                                     Vector(worldPosition)) else { throw MeshError.invalidLineSegment }
        
        return try Mesh.cap(line: line,
                            radius: shape.upperRadius,
                            color: .yellow)
    }
}
