//
//  Joint.swift
//
//  Created by Zack Brown on 10/11/2023.
//

import Euclid
import Foundation

internal enum Joint: String,
                     CaseIterable,
                     Hashable,
                     Identifiable {
    
    internal static var effectors: [Joint] { [.headEffector,
                                              .neckEffector,
                                              .hipEffector,
                                              .leftHandEffector,
                                              .rightHandEffector,
                                              .leftFootEffector,
                                              .rightFootEffector] }
    
    case headEffector = "Head Effector",
         neckEffector = "Neck Effector",
         hipEffector = "Hip Effector",
         leftHandEffector = "Left Hand Effector",
         rightHandEffector = "Right Hand Effector",
         leftFootEffector = "Left Foot Effector",
         rightFootEffector = "Right Foot Effector"

    case collarbone,
         leftShoulder = "Left Shoulder",
         rightShoulder = "Right Shoulder",
         leftElbow = "Left Elbow",
         rightElbow = "Right Elbow",
         leftWrist = "Left Wrist",
         rightWrist = "Right Wrist",
         chest,
         leftHip = "Left Hip",
         rightHip = "Right Hip",
         leftKnee = "Left Knee",
         rightKnee = "Right Knee",
         leftHeel = "Left Heel",
         rightHeel = "Right Heel",
         leftMidfoot = "Left Midfoot",
         rightMidfoot = "Right Midfoot"
    
    internal var id: String { rawValue.capitalized }
}
