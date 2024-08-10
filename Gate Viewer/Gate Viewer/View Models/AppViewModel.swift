//
//  AppViewModel.swift
//
//  Created by Zack Brown on 17/10/2023.
//

import Bivouac
import Deltille
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
    
    @Published var profile: Mesh.Profile = .init(polygonCount: 0,
                                                 vertexCount: 0)
    
    internal let scene = ModelViewScene()
    
    internal let avatar = Avatar()
    
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
    
    private func updateScene() {
        
        scene.clear()
        
        scene.render(surface: Grid.Triangle.zero.perimeter)
        
        scene.model = avatar
        
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
    
    private func updateProfile(for mesh: Mesh) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            self.profile = mesh.profile
        }
    }
}
