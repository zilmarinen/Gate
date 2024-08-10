//
//  Avatar.swift
//
//  Created by Zack Brown on 28/10/2023.
//

import Bivouac
import Foundation
import SceneKit

public class Avatar: SCNNode,
                     Updatable {
    
    internal let skeleton = Skeleton(.medium)
    
    internal lazy var marionette = Marionette(skeleton)
    internal lazy var skin = Skin(skeleton)
    
    public required override init() {
        
        super.init()
        
        addChildNode(marionette)
        
        let mesh = skin.mesh
        
        skinner = SCNSkinner(mesh: mesh,
                             bones: skeleton.bones,
                             boneInverseBindTransforms: skeleton.inverseBindTransforms)
        
        geometry = skinner?.baseGeometry
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public func update(_ delta: TimeInterval,
                       _ time: TimeInterval) {
        
        marionette.update(delta,
                          time)
    }
}
