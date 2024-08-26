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
    
    internal static func leg(_ pelvis: PelvisProfile,
                             _ ankle: AnkleProfile,
                             _ plane: Plane) throws -> Mesh {
        
        //ankle
        let (v0, v1, v2, v3, v4, v5) = ankle
        
        //calf
        let v6 = Vector(cos(Constant.legRadianStep) * Constant.kneeRadius,
                        Constant.calfLength,
                        sin(Constant.legRadianStep) * Constant.kneeRadius)
        let v7 = Vector(cos(Constant.legRadianStep * 2.0) * Constant.kneeRadius,
                        Constant.calfLength,
                        sin(Constant.legRadianStep * 2.0) * Constant.kneeRadius)
        let v8 = Vector(cos(Constant.legRadianStep * 3.0) * Constant.calfRadius,
                        Constant.calfLength,
                        sin(Constant.legRadianStep * 3.0) * Constant.calfRadius)
        let v9 = Vector(cos(Constant.legRadianStep * 4.0) * Constant.calfRadius,
                        Constant.calfLength,
                        sin(Constant.legRadianStep * 4.0) * Constant.calfRadius)
        let v10 = Vector(cos(Constant.legRadianStep * 5.0) * Constant.calfRadius,
                         Constant.calfLength,
                         sin(Constant.legRadianStep * 5.0) * Constant.calfRadius)
        let v11 = Vector(cos(Constant.legRadianStep * 6.0) * Constant.calfRadius,
                         Constant.calfLength,
                         sin(Constant.legRadianStep * 6.0) * Constant.calfRadius)
        
        //kneecap
        let v12 = Vector(cos(Constant.legRadianStep) * Constant.kneeRadius,
                         Bone.rightShin.maximumLength - Constant.kneeRadius,
                         sin(Constant.legRadianStep) * Constant.kneeRadius)
        let v13 = Vector(cos(Constant.legRadianStep * 2.0) * Constant.kneeRadius,
                         Bone.rightShin.maximumLength,
                         sin(Constant.legRadianStep * 2.0) * Constant.kneeRadius)
        let v14 = Vector(cos(Constant.legRadianStep * 3.0) * Constant.kneeRadius,
                         Bone.rightShin.maximumLength,
                         sin(Constant.legRadianStep * 3.0) * Constant.kneeRadius)
        let v15 = Vector(cos(Constant.legRadianStep * 4.0) * Constant.kneeRadius,
                         Bone.rightShin.maximumLength - Constant.kneeRadius,
                         sin(Constant.legRadianStep * 4.0) * Constant.kneeRadius)
        let v16 = Vector(cos(Constant.legRadianStep * 5.0) * Constant.kneeRadius,
                         Bone.rightShin.maximumLength - Constant.kneeRadius,
                         sin(Constant.legRadianStep * 5.0) * Constant.kneeRadius)
        let v17 = Vector(cos(Constant.legRadianStep * 6.0) * Constant.kneeRadius,
                         Bone.rightShin.maximumLength,
                         sin(Constant.legRadianStep * 6.0) * Constant.kneeRadius)
        
        let v18 = Vector(cos(Constant.legRadianStep) * Constant.kneeRadius,
                         Bone.rightShin.maximumLength,
                         sin(Constant.legRadianStep) * Constant.kneeRadius)
        let v19 = Vector(cos(Constant.legRadianStep) * Constant.kneeRadius,
                         Bone.rightShin.maximumLength + Constant.kneeRadius,
                         sin(Constant.legRadianStep) * Constant.kneeRadius)
        let v20 = Vector(sin(Constant.legRadianStep * 3.0) * Constant.kneeRadius,
                         Bone.rightShin.maximumLength,
                         cos(Constant.legRadianStep * 3.0) * Constant.kneeRadius)
        let v21 = Vector(sin(Constant.legRadianStep * 3.0) * Constant.kneeRadius,
                         Bone.rightShin.maximumLength + Constant.kneeRadius,
                         cos(Constant.legRadianStep * 3.0) * Constant.kneeRadius)
        
        //pelvis
        let (v22, v23, v24, v25, v26, v27, v28) = pelvis
        
        //thigh
        
        let ankleWinding = [v0, v1, v2, v3, v4, v5]
        let calfWinding = [v6, v7, v8, v9, v10, v11]
        let kneeWinding = [v12, v13, v14, v15, v16, v17]
        let faces = [[v12, v18, v13],
                     [v13, v18, v19],
                     [v18, v17, v19],
                     [v17, v18, v12],
                     [v15, v20, v16],
                     [v17, v20, v21],
                     [v17, v16, v20],
                     [v20, v15, v14],
                     [v21, v20, v14]]
        
        //shin
        var polygons = try Polygon.weave(ankleWinding,
                                         calfWinding,
                                         .red)
        
        //calf
        polygons.append(contentsOf: try Polygon.weave(calfWinding,
                                                      kneeWinding,
                                                      .yellow))
        
        //knee
        polygons.append(contentsOf: faces.compactMap { Polygon.face($0,
                                                                    .blue) })
        
        //thigh
        
        //pelvis
        try polygons.append(Polygon.face([v22, v23, v24, v25, v26, v27, v28], .unitY, .red))
        
        return Mesh(polygons)
    }
    
    internal static func foot(_ ankle: AnkleProfile) throws -> Mesh {

        let halfSize = Constant.footSize / 2.0
        let step = Vector(halfSize.x / 4.0,
                          halfSize.y / 4.0,
                          halfSize.z / 8.0)
        
        //perimeter
        let v0 = Vector(step.x * 2.0, (step.y * 2.0), Constant.footSize.z)
        let v1 = Vector(step.x * 3.0, (step.y * 2.0), Constant.footSize.z - (step.z * 2.0))
        let v2 = Vector(halfSize.x, (step.y * 2.0), Bone.leftHindfoot.maximumLength)
        let v3 = Vector(step.x * 3.0, (step.y * 3.0), 0.0)
        let v4 = Vector(step.x, halfSize.y, -step.z * 3.0)
        let v5 = Vector(-step.x, halfSize.y, -step.z * 3.0)
        let v6 = Vector(-step.x * 3.0, (step.y * 3.0), 0.0)
        let v7 = Vector(-halfSize.x, (step.y * 2.0), Bone.leftHindfoot.maximumLength)
        let v8 = Vector(-step.x * 3.0, (step.y * 2.0), Constant.footSize.z - (step.z * 3.0))
        let v9 = Vector(-step.x * 2.0, (step.y * 2.0), Constant.footSize.z - step.z)
        
        //ankle
        let (v10, v11, v12, v13, v14, v15) = ankle
        
        //bridge
        let v16 = Vector(-step.x * 2.0, (step.y * 3.0), Bone.leftHindfoot.maximumLength)
        let v17 = Vector(step.x * 2.0, (step.y * 3.0), Bone.leftHindfoot.maximumLength)
        
        let winding = [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9]
        let sole = winding.map { Vector($0.x, 0.0, $0.z) }
        let faces = [[v0, v1, v17],
                     [v1, v2, v17],
                     [v0, v17, v16],
                     [v0, v16, v9],
                     [v9, v16, v8],
                     [v8, v16, v7],
                     [v17, v10, v16],
                     [v16, v10, v11],
                     [v2, v10, v17],
                     [v16, v11, v7],
                     [v11, v6, v7],
                     [v11, v12, v6],
                     [v12, v13, v6],
                     [v13, v5, v6],
                     [v14, v5, v13],
                     [v14, v4, v5],
                     [v3, v4, v14],
                     [v3, v14, v15],
                     [v2, v3, v15],
                     [v2, v15, v10]]
        
        //base
        var polygons = try Polygon.weave(winding,
                                         sole,
                                         .blue)
        
        //bridge
        polygons.append(contentsOf: faces.compactMap { Polygon.face($0,
                                                                    .blue) })
        
        //sole
        try polygons.append(Polygon.face(sole.reversed(),
                                         .blue))
        
        return Mesh(polygons)
    }
}

extension Mesh {
    
    typealias PelvisProfile = (Vector, Vector, Vector, Vector, Vector, Vector, Vector)
    typealias AnkleProfile = (Vector, Vector, Vector, Vector, Vector, Vector)
    
    ///
    /// Returns a tuple of the seven vectors which define half of the circumference of the
    /// pelvic joints where the pelvis meets the torso.
    ///
    static func pelvisProfile() -> PelvisProfile {
        
        let c0 = Vector(-Constant.pelvisSize.x,
                         0.0,
                         -Constant.pelvisSize.z)
        let c1 = Vector(-Constant.pelvisSize.x,
                         0.0,
                         Constant.pelvisSize.z)
        
        let v0 = Vector(0.0,
                        0.0,
                        -Constant.pelvisSize.z)
        let v1 = Vector(-Constant.hipLength / 2.0,
                        0.0,
                        -Constant.pelvisSize.z)
        let v3 = Vector(-Constant.pelvisSize.x,
                         0.0,
                         0.0)
        let v5 = Vector(-Constant.hipLength / 2.0,
                        0.0,
                        Constant.pelvisSize.z)
        let v6 = Vector(0.0,
                        0.0,
                        Constant.pelvisSize.z)
        
        let v2 = QuadraticBezier(v1,
                                 v3,
                                 c0).integrate(0.5)
        let v4 = QuadraticBezier(v3,
                                 v5,
                                 c1).integrate(0.5)
        
        return (v0, v1, v2, v3, v4, v5, v6)
    }
    
    ///
    /// Returns a tuple of the six vectors which define the circumference of an
    /// ankle joint where the shin meets the foot.
    ///
    static func ankleProfile() -> AnkleProfile {
        
        let v0 = Vector(cos(Constant.legRadianStep) * Constant.ankleRadius,
                        Constant.footSize.y,
                        sin(Constant.legRadianStep) * Constant.ankleRadius)
        let v1 = Vector(cos(Constant.legRadianStep * 2.0) * Constant.ankleRadius,
                        Constant.footSize.y,
                        sin(Constant.legRadianStep * 2.0) * Constant.ankleRadius)
        let v2 = Vector(cos(Constant.legRadianStep * 3.0) * Constant.ankleRadius,
                        Constant.footSize.y,
                        sin(Constant.legRadianStep * 3.0) * Constant.ankleRadius)
        let v3 = Vector(cos(Constant.legRadianStep * 4.0) * Constant.ankleRadius,
                        Constant.footSize.y,
                        sin(Constant.legRadianStep * 4.0) * Constant.ankleRadius)
        let v4 = Vector(cos(Constant.legRadianStep * 5.0) * Constant.ankleRadius,
                        Constant.footSize.y,
                        sin(Constant.legRadianStep * 5.0) * Constant.ankleRadius)
        let v5 = Vector(cos(Constant.legRadianStep * 6.0) * Constant.ankleRadius,
                        Constant.footSize.y,
                        sin(Constant.legRadianStep * 6.0) * Constant.ankleRadius)
        
        return (v0, v1, v2, v3, v4, v5)
    }
}
