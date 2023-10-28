//
//  Height.swift
//
//  Created by Zack Brown on 21/10/2023.
//

import Foundation

extension Skeleton {
    
    public enum Height: Int,
                        CaseIterable,
                        Identifiable {
        
        case small
        case medium
        case tall
        
        public var id: String {
            
            switch self {
                
            case .small: return "Small"
            case .medium: return "Medium"
            case .tall: return "Tall"
            }
        }
        
        internal var armLength: Double {
            
            switch self {
                
            case .small: return 0.08
            case .medium: return 0.09
            case .tall: return 0.1
            }
        }
        
        internal var legLength: Double {
            
            switch self {
                
            case .small: return 0.08
            case .medium: return 0.09
            case .tall: return 0.1
            }
        }
        
        internal var limbRadius: Double {
            
            switch self {
                
            case .small: return 0.02
            case .medium: return 0.019
            case .tall: return 0.018
            }
        }
        
        internal var hairHeight: Double {
            
            switch self {
                
            case .small: return 0.03
            case .medium: return 0.04
            case .tall: return 0.05
            }
        }
        
        internal var faceHeight: Double {
            
            switch self {
                
            case .small: return 0.1
            case .medium: return 0.1
            case .tall: return 0.1
            }
        }
        
        internal var torsoHeight: Double {
            
            switch self {
                
            case .small: return 0.08
            case .medium: return 0.09
            case .tall: return 0.1
            }
        }
        
        internal var hipHeight: Double {
            
            switch self {
                
            case .small: return 0.03
            case .medium: return 0.04
            case .tall: return 0.05
            }
        }
    }
}
