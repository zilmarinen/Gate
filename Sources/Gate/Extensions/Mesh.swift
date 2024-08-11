//
//  Mesh.swift
//
//  Created by Zack Brown on 07/08/2024.
//

import Euclid

extension Mesh {
    
    internal static func head() -> Mesh { Mesh([]) }
    
    internal static func torso(_ height: Double) -> Mesh {
        
        let v0 = Vector(0.05, 0.0, 0.015)
        let v1 = Vector(-0.05, 0.0, 0.015)
        let v2 = Vector(-0.05, 0.0, -0.015)
        let v3 = Vector(0.05, 0.0, -0.015)
        
        return Mesh.wrap([v3, v2, v1, v0],
                         nil,
                         .yellow,
                         height)
    }
    
    internal static func pelvis(_ height: Double) -> Mesh {
        
        let v0 = Vector(0.05, 0.0, 0.01)
        let v1 = Vector(-0.05, 0.0, 0.01)
        let v2 = Vector(-0.05, 0.0, -0.01)
        let v3 = Vector(0.05, 0.0, -0.01)
        
        return Mesh.wrap([v3, v2, v1, v0],
                         nil,
                         .blue,
                         height)
    }
    
    internal static func arm(_ length: Double) -> Mesh { Mesh([]) }
    
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
