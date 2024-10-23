//
//  Foot.swift
//
//  Created by Zack Brown on 28/08/2024.
//

import Euclid

extension Mesh {
    
    internal static func foot(_ ankle: Ankle) throws -> Mesh {

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
        let (v10, v11, v12, v13, v14, v15) = ankle.profile
        
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
