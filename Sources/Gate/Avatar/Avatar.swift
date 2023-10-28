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
    
    internal var marionette: Marionette
    
    public var skeleton: Skeleton {
        
        get { marionette.skeleton }
        set {
            
            marionette.removeFromParentNode()
            
            marionette = Marionette(skeleton: newValue)
            
            addChildNode(marionette)
        }
    }
    
    public required init(skeleton: Skeleton) {
        
        self.marionette = Marionette(skeleton: skeleton)
        
        super.init()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        marionette.update(delta: delta,
                          time: time)
    }
}
