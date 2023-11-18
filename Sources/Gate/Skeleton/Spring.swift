//
//  Spring.swift
//
//  Created by Zack Brown on 13/11/2023.
//

import Foundation

public struct Spring {
    
    let minimumLength: Double
    let maximumLength: Double
    
    public init(_ length: Double) {
        
        self.minimumLength = length
        self.maximumLength = length
    }
    
    public init(_ minimumLength: Double,
                _ maximumLength: Double) {
        
        self.minimumLength = min(minimumLength, maximumLength)
        self.maximumLength = max(minimumLength, maximumLength)
    }
}
