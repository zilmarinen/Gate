//
//  Pelvis.swift
//
//  Created by Zack Brown on 28/08/2024.
//

import Bivouac
import Euclid

extension Mesh {
    
    ///
    /// A struct for the seven vectors which define half of the circumference of the
    /// pelvic joints where the pelvis meets the torso.
    ///
    struct Pelvis: MeshProfile {
        
        typealias Profile = (Vector, Vector, Vector, Vector, Vector, Vector, Vector)
        
        internal private(set)var vectors: [Vector]
        
        internal var profile: Profile { (vectors[0],
                                         vectors[1],
                                         vectors[2],
                                         vectors[3],
                                         vectors[4],
                                         vectors[5],
                                         vectors[6]) }
        
        internal init(vectors: [Vector]) {
            
            self.vectors = vectors
        }
        
        internal init() {
            
            let y = Bone.leftShin.maximumLength + Bone.leftThigh.maximumLength + (Constant.pelvisSize.y / 2.0)
            
            let c0 = Vector(-Constant.pelvisSize.x,
                             y,
                             -Constant.pelvisSize.z)
            let c1 = Vector(-Constant.pelvisSize.x,
                             y,
                             Constant.pelvisSize.z)
            
            let v0 = Vector(0.0,
                            y,
                            -Constant.pelvisSize.z)
            let v1 = Vector(-Constant.hipLength / 2.0,
                             y,
                             -Constant.pelvisSize.z)
            let v3 = Vector(-Constant.pelvisSize.x,
                             y,
                             0.0)
            let v5 = Vector(-Constant.hipLength / 2.0,
                             y,
                             Constant.pelvisSize.z)
            let v6 = Vector(0.0,
                            y,
                            Constant.pelvisSize.z)
            
            let v2 = QuadraticBezier(v1,
                                     v3,
                                     c0).integrate(0.5)
            let v4 = QuadraticBezier(v3,
                                     v5,
                                     c1).integrate(0.5)
            
            self.vectors = [v0, v1, v2, v3, v4, v5, v6]
        }
    }
}
