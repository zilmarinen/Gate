//
//  Spring.swift
//
//  Created by Zack Brown on 13/11/2023.
//

import Foundation

internal struct Spring {
    
    internal let minimumLength: Double
    internal let maximumLength: Double
    
    internal  init(_ length: Double) {
        
        self.minimumLength = length
        self.maximumLength = length
    }
    
    internal  init(_ minimumLength: Double,
                   _ maximumLength: Double) {
        
        self.minimumLength = min(minimumLength, maximumLength)
        self.maximumLength = max(minimumLength, maximumLength)
    }
}
