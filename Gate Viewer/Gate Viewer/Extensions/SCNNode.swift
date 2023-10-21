//
//  SCNNode.swift
//
//  Created by Zack Brown on 19/10/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

extension SCNNode {
    
    public func debug(showBones: Bool,
                      showJoints: Bool,
                      showMesh: Bool) throws {
        
        try childNodes.forEach { try $0.debug(showBones: showBones,
                                              showJoints: showJoints,
                                              showMesh: showMesh) }
        
        if parent == nil && showMesh { return }
        
        let material = SCNMaterial()
        material.diffuse.contents = NSColor.systemPink
        
        var mesh = Mesh([])
        
        if showJoints {
            
            mesh = mesh.union(Mesh.cube(size: Vector(size: 0.005),
                                          material: material))
        }
        
        if showBones {
        
            for child in childNodes {
                
                guard let line = LineSegment(start: .zero,
                                             end: Vector(child.position)) else { continue }
                
                mesh = mesh.union(try Mesh.bone(line: line,
                                                color: .green))
            }
        }
        
        self.geometry = SCNGeometry(wireframe: mesh)
    }
}
