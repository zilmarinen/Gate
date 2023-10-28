//
//  ViewerScene.swift
//
//  Created by Zack Brown on 23/10/2023.
//

import Bivouac
import Foundation
import Gate
import SceneKit

internal class ViewerScene: Scene {
    
    internal var avatar = Avatar(skeleton: .default)
    
    internal var pedestal = Pedestal()
    
    required init() {
        
        super.init()
        
        //
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func update(delta: TimeInterval,
                         time: TimeInterval) {
    
        super.update(delta: delta,
                     time: time)
        
        avatar.update(delta: delta,
                      time: time)
    }
    
    override func clear() {
        
        super.clear()
        
        rootNode.addChildNode(avatar)
        //rootNode.addChildNode(pedestal)
    }
}
