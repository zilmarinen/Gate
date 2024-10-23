//
//  MeshProfile.swift
//
//  Created by Zack Brown on 28/08/2024.
//

import Euclid

internal protocol MeshProfile {
    
    associatedtype Profile
    
    var vectors: [Vector] { get }
    
    var profile: Profile { get }
    
    init(vectors: [Vector])
    
    func transformed(_ offset: Vector) -> Self
    func projected(_ plane: Plane) -> Self
}

internal extension MeshProfile {
    
    func transformed(_ offset: Vector) -> Self { Self(vectors: vectors.map { $0 + offset }) }
    
    func projected(_ plane: Plane) -> Self { Self(vectors: vectors.map { $0.project(onto: plane) }) }
}
