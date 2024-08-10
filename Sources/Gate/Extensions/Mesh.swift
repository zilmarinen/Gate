//
//  Mesh.swift
//
//  Created by Zack Brown on 07/08/2024.
//

import Euclid

extension Mesh {
    
    internal static func head() -> Mesh { Mesh.cube(size: Vector(size: 0.01)) }
    
    internal static func torso() -> Mesh { Mesh([]) }
    
    internal static func pelvis() -> Mesh { Mesh([]) }
    
    internal static func arm() -> Mesh { Mesh([]) }
    
    internal static func leg(_ length: Double) -> Mesh {
        
        let mid = length / 2.0
        
        let v0 = Vector(0.01, 0.0, 0.01)
        let v1 = Vector(-0.01, 0.0, 0.01)
        let v2 = Vector(-0.01, 0.0, -0.01)
        let v3 = Vector(0.01, 0.0, -0.01)
        
        let face = [v3, v2, v1, v0]
        
        let shin = Mesh.wrap(face,
                             nil,
                             .red,
                             mid)
        
        let thigh = Mesh.wrap(face.map { $0 + Vector(0.0, mid, 0.0) },
                              nil,
                              .green,
                              mid)
        
        return shin.union(thigh)
    }
}
