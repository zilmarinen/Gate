//
//  Skeleton.swift
//
//  Created by Zack Brown on 17/10/2023.
//

import Bivouac
import Euclid
import Foundation
import SceneKit

public class Skeleton: SCNNode,
                       Bindable,
                       Meshable {
    
    internal let hair = Hair()
    internal let face = Face()
    internal let torso = Torso()
    internal let hips = Hips()
    
    internal let leftShoulder = Limb(side: .left,
                                     appendage: .arm)
    internal let leftHip = Limb(side: .left,
                                appendage: .leg)
    
    internal let rightShoulder = Limb(side: .right,
                                      appendage: .arm)
    internal let rightHip = Limb(side: .right,
                                 appendage: .leg)
    
    internal let height: Height
    internal let shape: Shape
    
    public init(height: Height,
                shape: Shape) {
        
        self.height = height
        self.shape = shape
        
        super.init()
        
        self.name = "Root"
        
        addChildNode(hips)
        
        hips.addChildNode(torso)
        hips.addChildNode(leftHip)
        hips.addChildNode(rightHip)
        
        torso.addChildNode(face)
        torso.addChildNode(leftShoulder)
        torso.addChildNode(rightShoulder)
        
        face.addChildNode(hair)
        
        bindPose(height: height,
                 shape: shape)
        
        guard let mesh = try? mesh(height: height,
                                   shape: shape,
                                   color: .clear) else { return }
        
        self.geometry = SCNGeometry(mesh)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Skeleton {
 
    internal var bones: [SCNNode] { recursiveChildren }
    internal var inverseBindTransforms: [NSValue] { bones.map { NSValue(scnMatrix4: $0.transform) } }
}

extension Skeleton {
    
    internal func bindPose(height: Skeleton.Height,
                           shape: Skeleton.Shape) {
        
        position = SCNVector3(0.0, 0.0, 0.0)
        
        hair.bindPose(height: height,
                      shape: shape)
        face.bindPose(height: height,
                      shape: shape)
        torso.bindPose(height: height,
                       shape: shape)
        hips.bindPose(height: height,
                      shape: shape)
        leftShoulder.bindPose(height: height,
                              shape: shape)
        rightShoulder.bindPose(height: height,
                               shape: shape)
        leftHip.bindPose(height: height,
                         shape: shape)
        rightHip.bindPose(height: height,
                          shape: shape)
    }
}

extension Skeleton {
    
    func mesh(height: Skeleton.Height,
              shape: Skeleton.Shape,
              color: Color) throws -> Mesh {
        
        do {
            
            let color = Color("FFB7B7")
            
            let nodes: [Meshable] = [hair,
                                     face,
                                     torso,
                                     hips,
                                     leftShoulder,
                                     rightShoulder,
                                     leftHip,
                                     rightHip]
            
            let submeshes = try nodes.map { try $0.mesh(height: height,
                                                        shape: shape,
                                                        color: color) }
            
            return Mesh(submeshes: submeshes)
        }
        catch {
            
            fatalError(error.localizedDescription)
        }
    }
}
