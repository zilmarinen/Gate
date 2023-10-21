//
//  Meshable.swift
//
//  Created by Zack Brown on 21/10/2023.
//

import Euclid
import Foundation

internal protocol Meshable {
    
    func mesh(height: Skeleton.Height,
              shape: Skeleton.Shape,
              color: Color) throws -> Mesh
}
