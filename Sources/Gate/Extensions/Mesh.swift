//
//  Mesh.swift
//
//  Created by Zack Brown on 07/08/2024.
//

import Bivouac
import Euclid

extension Mesh {
    
    internal static func head(_ size: Vector) throws -> Mesh {
        
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
                
                //lerp corners towards center
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
    
    internal static func torso(_ height: Double) throws -> Mesh {
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
    
    internal static func pelvis(_ height: Double) throws -> Mesh {
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
    
    internal static func arm() throws -> Mesh { Mesh([]) }
    
    internal enum Constant {
        
        //pelvis
        static let hipLength = Bone.leftHipbone.maximumLength
        static let pelvisSize = Vector(hipLength * 2.0,
                                       hipLength,
                                       hipLength)
        
        //legs
        static let legLength = Bone.leftThigh.maximumLength + shinLength
        static let shinLength = Bone.leftShin.maximumLength - footSize.y
        static let legRadianStep = Angle(radians: Double.tau / 6.0)
        static let calfLength = shinLength * 0.75
        static let calfRadius = calfLength / 8.0
        static let kneeRadius = calfLength / 10.0
        
        //feet
        static let footLength = Bone.leftHindfoot.maximumLength + Bone.leftForefoot.maximumLength
        static let footSize = Vector(footLength / 2.0,
                                     footLength / 4.0,
                                     footLength)
        static let ankleRadius = footLength / 8.0
    }
}
