//
//  Joint.swift
//
//  Created by Zack Brown on 10/11/2023.
//

import Foundation

public protocol SkeletonJoint: CaseIterable,
                               Hashable,
                               Identifiable {
    
    var id: String { get }
}
