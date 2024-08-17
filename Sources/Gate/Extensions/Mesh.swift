//
//  Mesh.swift
//
//  Created by Zack Brown on 07/08/2024.
//

import Bivouac
import Euclid

extension Mesh {
    
    internal static func head() throws -> Mesh {
        
        let size = Vector(0.04, 0.06, 0.03)
        let offset = 0.1
        let slice = size.y / 4.0
        let normal = Vector(0.0, 1.0 + offset, -offset).normalized()
        
        guard let neckPlane = Plane(normal: normal,
                                    pointOnPlane: Vector(0.0, slice * 0.5, 0.0)),
              let chinPlane = Plane(normal: normal,
                                    pointOnPlane: Vector(0.0, slice * 1.5, 0.0)),
              let headPlane = Plane(normal: normal,
                                    pointOnPlane: Vector(0.0, slice * 3.5, 0.0)) else { return Mesh([]) }
        
        //corners
        let c0 = Vector(size.x, 0.0, size.z)
        let c1 = Vector(size.x, 0.0, -size.z)
        let c2 = Vector(-size.x, 0.0, -size.z)
        let c3 = Vector(-size.x, 0.0, size.z)
        
        //mid points
        let m0 = Vector(0.0, 0.0, size.z)
        let m1 = Vector(size.x, 0.0, 0.0)
        let m2 = Vector(0.0, 0.0, -size.z)
        let m3 = Vector(-size.x, 0.0, 0.0)
        
        func project(_ vertices: [Vector],
                     _ plane: Plane,
                     _ offset: Double) -> [Vector] {
            
            var projected: [Vector] = []
            
            let center = plane.normal * plane.w
            
            for i in vertices.indices {
                
                var vector = vertices[i].project(onto: plane)
                
                if i % 2 == 0 {
                    
                    vector = vector.lerp(center,
                                         offset)
                }
                
                projected.append(vector)
            }
            
            return projected
        }
        
        let winding = [c3, m3, c2, m2, c1, m1, c0, m0]
        
        let neckVertices = project(winding,
                                   neckPlane,
                                   offset * 2.0)
        let chinVertices = project(winding,
                                   chinPlane,
                                   offset * 0.5)
        let headVertices = project(winding,
                                   headPlane,
                                   offset * 2.0)
        
        let neck = try Polygon.wind(neckVertices,
                                    .zero,
                                    .green)
        let chin = try Polygon.weave(neckVertices,
                                     chinVertices,
                                     .blue)
        let face = try Polygon.weave(chinVertices,
                                     headVertices,
                                     .orange)
        let head = try Polygon.wind(headVertices.reversed(),
                                    Vector(0.0, size.y, 0.0),
                                    .red)
        
        return Mesh(neck + chin + face + head)
    }
    
    internal static func torso(_ height: Double) -> Mesh {
        return Mesh([])
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
        return Mesh([])
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
        return Mesh([])
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
