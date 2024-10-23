//
//  Leg.swift
//
//  Created by Zack Brown on 28/08/2024.
//

import Euclid

extension Mesh {
    
    internal static func leg(_ pelvis: Pelvis,
                             _ ankle: Ankle,
                             _ plane: Plane) throws -> Mesh {
        
        //pelvis
        let pelvis = pelvis.transformed(Vector(Constant.hipLength,
                                               0.0,
                                               0.0))
        
        //ankle
        let (v0, v1, v2, v3, v4, v5) = ankle.profile
        
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
        let (v22, v23, v24, v25, v26, v27, v28) = pelvis.profile
        
        //thigh
        let (v29, v30, v31, v32, v33, v34, v35) = pelvis.projected(plane).profile
        
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
//                     [v19, v17, v35],
//                     [v19, v35, v34],
//                     [v19, v34, v13],
//                     [v13, v34, v33],
//                     [v13, v33, v14],
//                     [v14, v33, v32],
//                     [v14, v32, v21],
//                     [v21, v32, v31],
//                     [v21, v31, v30],
//                     [v21, v30, v35],
//                     [v17, v21, v35]]
        
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
        //try polygons.append(Polygon.face([v22, v23, v24, v25, v26, v27, v28], .unitY, .red))
        
        return Mesh(polygons)
    }
}
