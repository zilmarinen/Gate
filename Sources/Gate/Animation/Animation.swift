//
//  Animation.swift
//
//  Created by Zack Brown on 09/08/2024.
//

import Bivouac
import Euclid
import Foundation

internal class Animation: Updatable {
    
    internal var elapsed: TimeInterval = 0
    internal var playhead: TimeInterval = 0
    
    internal let keyframes: [Keyframe]
    internal let repeats: Bool
    internal let duration: TimeInterval
    
    internal init(_ keyframes: [Keyframe],
                  _ repeats: Bool) {
        
        self.keyframes = keyframes.sorted { $0.timestamp < $1.timestamp }
        self.repeats = repeats
        self.duration = keyframes.last?.timestamp ?? 0
    }
}

extension Animation {
    
    internal func update(_ delta: TimeInterval,
                         _ time: TimeInterval) {
        
        elapsed += delta
        playhead += delta
        
        if playhead > duration {
            
            guard repeats else { return }
            
            playhead -= duration
        }
    }
}

extension Animation {
    
    internal func previousFrame(_ joint: Joint) -> Keyframe? {
        
        let frames = keyframes.filter { $0.timestamp <= playhead }
        
        return frames.first { $0.poses.first { $0.joint == joint } != nil }
    }
    
    internal func nextFrame(_ joint: Joint) -> Keyframe? {
        
        let frames = keyframes.filter { $0.timestamp >= playhead }
        
        return frames.first { $0.poses.first { $0.joint == joint } != nil }
    }
}
