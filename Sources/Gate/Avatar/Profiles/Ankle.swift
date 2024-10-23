//
//  Ankle.swift
//
//  Created by Zack Brown on 28/08/2024.
//

import Bivouac
import Euclid

extension Mesh {
    
    ///
    /// A struct for the six vectors which define the circumference of an
    /// ankle joint where the shin meets the foot.
    ///
    struct Ankle: MeshProfile {
        
        typealias Profile = (Vector, Vector, Vector, Vector, Vector, Vector)
        
        internal private(set)var vectors: [Vector]
        
        internal var profile: Profile { (vectors[0],
                                         vectors[1],
                                         vectors[2],
                                         vectors[3],
                                         vectors[4],
                                         vectors[5]) }
        
        internal init(vectors: [Vector]) { self.vectors = vectors }
        
        internal init() {
            
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
            
            self.vectors = [v0, v1, v2, v3, v4, v5]
        }
    }
}
