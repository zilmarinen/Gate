//
//  Bone.swift
//
//  Created by Zack Brown on 10/11/2023.
//

import Foundation

public protocol SkeletonBone: CaseIterable,
                              Identifiable {
    
    var id: String { get }
}
