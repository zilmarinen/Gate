//
//  Shape.swift
//
//  Created by Zack Brown on 21/10/2023.
//

import Foundation

extension Skeleton {
    
    public enum Shape: Int,
                       CaseIterable,
                       Identifiable {
       
        case cyclinder
        case taperedDown
        case taperedUp
       
        public var id: String {
           
            switch self {
               
            case .cyclinder: return "Cyclinder"
            case .taperedDown: return "Tapered Down"
            case .taperedUp: return "Tapered Up"
            }
        }
        
        internal var upperRadius: Double {
            
            switch self {
                
            case .cyclinder: return 0.1
            case .taperedDown: return 0.15
            case .taperedUp: return 0.2
            }
        }
        
        internal var lowerRadius: Double {
            
            switch self {
                
            case .cyclinder: return 0.1
            case .taperedDown: return 0.15
            case .taperedUp: return 0.2
            }
        }
        
        internal var limbRadius: Double { 0.01 }        
    }
}
