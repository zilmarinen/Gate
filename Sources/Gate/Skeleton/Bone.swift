//
//  Bone.swift
//
//  Created by Zack Brown on 10/11/2023.
//

import Foundation

internal enum Bone: String,
                    CaseIterable,
                    Identifiable {
    
    case head,
         neck,
         leftClavicle = "Left Clavicle",
         rightClavicle = "Right Clavicle",
         leftArm = "Left Arm",
         rightArm = "Right Arm",
         leftForearm = "Left Forearm",
         rightForearm = "Right Forearm",
         leftHand = "Left Hand",
         rightHand = "Right Hand",
         spineUpper = "Spine Upper",
         spineLower = "Spine Lower",
         leftHipbone = "Left Hipbone",
         rightHipbone = "Right Hipbone",
         leftThigh = "Left Thigh",
         rightThigh = "Right Thigh",
         leftShin = "Left Shin",
         rightShin = "Right Shin",
         leftFoot = "Left Foot",
         rightFoot = "Right Foot"
    
    internal var id: String { rawValue.capitalized }
}

import Bivouac
import Euclid

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
            
            let top = Polygon.face([line.start,
                                    v1,
                                    v0],
                                    color)
            
            let bottom = Polygon.face([v0,
                                       v1,
                                       line.end],
                                       color)
            
            try polygons.append(top)
            try polygons.append(bottom)
        }
        
        return Mesh(polygons)
    }
}
