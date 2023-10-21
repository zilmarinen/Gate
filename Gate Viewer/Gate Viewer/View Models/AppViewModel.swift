//
//  AppViewModel.swift
//
//  Created by Zack Brown on 17/10/2023.
//

import Bivouac
import Euclid
import Foundation
import Gate
import SceneKit

class AppViewModel: ObservableObject {
    
    @Published var showBones: Bool = true {
        
        didSet {
            
            guard oldValue != showBones else { return }
            
            updateScene()
        }
    }
    
    @Published var showJoints: Bool = true {
        
        didSet {
            
            guard oldValue != showJoints else { return }
            
            updateScene()
        }
    }
    
    @Published var showMesh: Bool = true {
        
        didSet {
            
            guard oldValue != showMesh else { return }
            
            updateScene()
        }
    }
    
    @Published var height: Skeleton.Height = .small {
        
        didSet {
            
            guard oldValue != height else { return }
            
            updateScene()
        }
    }
    
    @Published var shape: Skeleton.Shape = .cyclinder {
        
        didSet {
            
            guard oldValue != shape else { return }
            
            updateScene()
        }
    }
    
    @Published var profile: Mesh.Profile = .init(polygonCount: 0,
                                                 vertexCount: 0)
    
    internal let scene = Scene()
    
    private let operationQueue = OperationQueue()
    
    init() {
        
        generateModel()
    }
}

extension AppViewModel {
    
    private func generateModel() {
        
//        let operation = TerrainCacheOperation()
//
//        operation.enqueue(on: operationQueue) { [weak self] result in
//
//            guard let self else { return }
//
//            switch result {
//
//            case .success(let cache): self.cache = cache
//            case .failure(let error): fatalError(error.localizedDescription)
//            }
//
//            self.updateScene()
//        }
        
        updateScene()
    }
    
    private func createNode(with mesh: Mesh?) -> SCNNode? {
        
        guard let mesh else { return nil }
        
        let node = SCNNode()
        let wireframe = SCNNode()
        let material = SCNMaterial()
        
        node.geometry = SCNGeometry(mesh)
        node.geometry?.firstMaterial = material
        
        wireframe.geometry = SCNGeometry(wireframe: mesh)
        
        node.addChildNode(wireframe)
        
        return node
    }
    
    private func updateScene() {
        
        self.scene.clear()
        
        self.updateSurface()
        
        let skeleton = Skeleton(height: height,
                                shape: shape)
        
        try? skeleton.debug(showBones: showBones,
                            showJoints: showJoints,
                            showMesh: showMesh)
        
        self.scene.rootNode.addChildNode(skeleton)
        
//        guard let cache,
//              let mesh = cache.mesh(for: kite,
//                                    terrainType: terrainType,
//                                    elevation: elevation),
//              let node = self.createNode(with: mesh) else { return }
//
//        self.scene.rootNode.addChildNode(node)
//
//        self.updateProfile(for: mesh)
    }
    
    private func updateSurface() {
        
        let vertices = Grid.Triangle.zero.corners(for: .tile).map { Vertex($0, .up) }
        
        guard let polygon = Polygon(vertices) else { return }
        
        let mesh = Mesh([polygon])
        
        guard let node = createNode(with: mesh) else { return }
        
        scene.rootNode.addChildNode(node)
    }
    
    private func updateProfile(for mesh: Mesh) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            self.profile = mesh.profile
        }
    }
}
