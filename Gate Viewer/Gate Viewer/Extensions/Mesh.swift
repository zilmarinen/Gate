//
//  Mesh.swift
//  Gate Viewer
//
//  Created by Zack Brown on 19/10/2023.
//

import Bivouac
import Euclid
import Foundation

extension Mesh {
    
    public static func bone(line: LineSegment,
                            color: Color) throws -> Mesh {
        
        let steps = 4
        let step = (.pi2 / Double(steps))
        let radius = line.length * 0.05
        let direction = line.direction
        let base = line.start.lerp(line.end, 0.1)
        let apex = line.end.lerp(line.start, 0.1)
        let anchor = base.lerp(apex, 0.1)
        let perpendicular = direction.perpendicular.normalized()
        let binormal = direction.cross(perpendicular)
        
        var polygons: [Euclid.Polygon] = []
        
        for i in 0..<steps {
            
            let iStep = step * Double(i)
            let jStep = step * Double((i + 1) % steps)
            
            let v0 = anchor + radius * perpendicular * cos(iStep) + radius * binormal * sin(iStep)
            let v1 = anchor + radius * perpendicular * cos(jStep) + radius * binormal * sin(jStep)
            
            let top = Polygon.Face([line.start,
                                    v1,
                                    v0],
                                    color: color)
            
            let bottom = Polygon.Face([v0,
                                       v1,
                                       line.end],
                                       color: color)
            
            try polygons.glue(top?.polygon)
            try polygons.glue(bottom?.polygon)
        }
        
        return Mesh(polygons)
    }
}
