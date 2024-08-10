//
//  SCNGeometrySource.swift
//
//  Created by Zack Brown on 07/08/2024.
//

import SceneKit

extension SCNGeometrySource {
    
    internal convenience init(colors: [SCNVector4]) {
        
        let data = Data(bytes: colors, 
                        count: colors.count * MemoryLayout<SCNVector4>.size)

        self.init(data: data,
                  semantic: .color,
                  vectorCount: colors.count,
                  usesFloatComponents: true,
                  componentsPerVector: 4,
                  bytesPerComponent: MemoryLayout<Double>.size,
                  dataOffset: 0,
                  dataStride: 0)
    }
    
    internal convenience init(boneIndices: [UInt16]) {
    
        let data = Data(bytes: boneIndices,
                        count: boneIndices.count * MemoryLayout<UInt16>.size)

        self.init(data: data,
                  semantic: .boneIndices,
                  vectorCount: boneIndices.count,
                  usesFloatComponents: false,
                  componentsPerVector: 1,
                  bytesPerComponent: MemoryLayout<UInt16>.size,
                  dataOffset: 0,
                  dataStride: 0)
    }

    internal convenience init(boneWeights: [Float]) {
    
        let data = Data(bytes: boneWeights,
                        count: boneWeights.count * MemoryLayout<Float>.size)

        self.init(data: data,
                  semantic: .boneWeights,
                  vectorCount: boneWeights.count,
                  usesFloatComponents: true,
                  componentsPerVector: 1,
                  bytesPerComponent: MemoryLayout<Float>.size,
                  dataOffset: 0,
                  dataStride: 0)
    }
}
