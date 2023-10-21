//
//  Bindable.swift
//
//  Created by Zack Brown on 21/10/2023.
//

import Foundation

internal protocol Bindable {
    
    func bindPose(height: Skeleton.Height,
                  shape: Skeleton.Shape)
}
