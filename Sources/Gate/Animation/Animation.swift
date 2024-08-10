//
//  Animation.swift
//
//  Created by Zack Brown on 09/08/2024.
//

import Bivouac
import Euclid
import Foundation

internal struct Animation: Updatable {
    
    internal let keyframes: [Keyframe]
    internal let repeats: Bool
    
    internal init(_ keyframes: [Keyframe],
                  _ repeats: Bool) {
        
        self.keyframes = keyframes.sorted { $0.timestamp < $1.timestamp }
        self.repeats = repeats
    }
}

extension Animation {
    
    func update(_ delta: TimeInterval,
                _ time: TimeInterval) {
        
        //
    }
}
