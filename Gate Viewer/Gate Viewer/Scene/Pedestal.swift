//
//  Pedestal.swift
//
//  Created by Zack Brown on 25/10/2023.
//

import Euclid
import Foundation
import SceneKit

internal class Pedestal: SCNNode {
    
    enum Constant {
        
        internal static let pedestalRadius = 0.5
        internal static let pedestalHeight = 0.01
        
        internal static let nodeSize = 0.01
        
        internal static let innerRadius = 0.3
    }
    
    internal lazy var movement: SCNNode = {
        
        let node = SCNNode()
        
        node.geometry = SCNGeometry(Mesh.cube(size: Vector(size: Constant.nodeSize),
                                              material: Color.red))
        node.position = SCNVector3(Constant.pedestalRadius * cos(0),
                                   Constant.nodeSize / 2.0,
                                   Constant.pedestalRadius * sin(0))
        
        return node
    }()
    
    internal lazy var look: SCNNode = {
        
        let node = SCNNode()
        
        node.geometry = SCNGeometry(Mesh.cube(size: Vector(size: Constant.nodeSize),
                                              material: Color.green))
        node.position = SCNVector3(Constant.innerRadius * cos(0),
                                   Constant.nodeSize / 2.0,
                                   Constant.innerRadius * sin(0))
        
        return node
    }()
    
    internal override init() {
        
        super.init()
        
        self.geometry = SCNGeometry(Mesh.cylinder(radius: Constant.pedestalRadius,
                                                  height: Constant.pedestalHeight))
        
        addChildNode(movement)
        addChildNode(look)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
