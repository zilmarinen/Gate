//
//  Skeleton.swift
//
//  Created by Zack Brown on 17/10/2023.
//

import Euclid
import Foundation
import SceneKit

public enum Endoskeleton {}

public protocol Skeleton: SCNNode {
    
    associatedtype B: SkeletonBone
    associatedtype J: SkeletonJoint
    
    var rootNode: J { get }
    
    var boneStructure: [B] { get }
    
    var effectors: [J] { get }
    
    var joints: [J] { get }
    
    var tPose: [J : Transform] { get }
    
    var bones: [SCNNode] { get }
    var inverseBindTransforms: [NSValue] { get }
    
    func bind()
    
    func childNode(_ joint: J) -> SCNNode?
    
    func startJoint(for bone: B) -> J
    func endJoint(for bone: B) -> J
    
    func spring(for bone: B) -> Spring
}

extension Skeleton {
    
    public var bones: [SCNNode] { recursiveChildren }
    
    public var inverseBindTransforms: [NSValue] { bones.map { NSValue(scnMatrix4: SCNMatrix4Invert($0.worldTransform)) } }
}

extension Skeleton {
    
    public func bind() {

        for bone in boneStructure {
            
            let start = startJoint(for: bone)
            let end = endJoint(for: bone)
            let spring = spring(for: bone)
            
            let startNode = childNode(start) ?? SCNNode(start.id)
            let endNode = childNode(end) ?? SCNNode(end.id)
            
            let constraint = SCNDistanceConstraint(target: startNode)
            
            constraint.minimumDistance = spring.minimumLength
            constraint.maximumDistance = spring.maximumLength
            
            endNode.addConstraint(constraint)
            endNode.transform = SCNMatrix4(tPose[end] ?? .identity)
            
            startNode.addChildNode(endNode)

            guard startNode.parent == nil else { continue }

            startNode.transform = SCNMatrix4(tPose[start] ?? .identity)
            
            addChildNode(startNode)
        }
        
        for joint in joints {
            
            guard let node = childNode(joint) else { continue }
            
            var mesh = Mesh([])
            
            for child in node.childNodes {
                
                guard let bone = try? Mesh.bone(start: .zero,
                                                end: Vector(child.position),
                                                color: .black) else { continue }
                
                mesh = mesh.merge(bone)
            }
            
            let child = SCNNode()
            
            child.geometry = SCNGeometry(mesh)
            
            node.addChildNode(child)
        }
    }
    
    public func childNode(_ joint: J) -> SCNNode? { childNode(withName: joint.id,
                                                                  recursively: true) }
}
