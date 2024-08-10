//
//  SCNSkinner.swift
//
//  Created by Zack Brown on 07/08/2024.
//

import Euclid
import SceneKit

extension SCNSkinner {
    
    internal convenience init(mesh: Mesh,
                              bones: [SCNNode],
                              boneInverseBindTransforms: [NSValue]) {
        
        var elements: [SCNGeometryElement] = []
        var vertices: [SCNVector3] = []
        var normals: [SCNVector3] = []
        var textureCoordinates: [CGPoint] = []
        var colors: [SCNVector4] = []
        var boneIndices: [UInt16] = []
        var boneWeights: [Float] = []
        var indicesByVertex: [Vertex : UInt32] = [:]
        let hasTextureCoordinates = mesh.hasTexcoords
        let hasVertexNormals = mesh.hasVertexNormals
        let hasVertexColors = mesh.hasVertexColors
        
        for material in mesh.materials {
            
            let polygons = mesh.polygonsByMaterial[material] ?? []
            
            var indices: [UInt32] = []
            
            let triangles = polygons.flatMap { $0.triangulate() }
            
            for triangle in triangles {
                
                for vertex in triangle.vertices {
                    
                    if let index = indicesByVertex[vertex] {
                        
                        indices.append(index)
                        
                        continue
                    }
                    
                    let index = UInt32(indicesByVertex.count)
                    
                    indicesByVertex[vertex] = index
                    
                    indices.append(index)
                    
                    vertices.append(SCNVector3(vertex.position))
                    
                    if hasTextureCoordinates {
                        
                        textureCoordinates.append(CGPoint(vertex.texcoord))
                    }
                    
                    if hasVertexNormals {
                        
                        normals.append(SCNVector3(vertex.normal))
                    }
                    
                    if hasVertexColors {
                        
                        colors.append(SCNVector4(vertex.color))
                    }
                    
                    let contribution = Bone.influence(vertex.position,
                                                      bones)
                    
                    boneIndices.append(contentsOf: contribution.indices)
                    boneWeights.append(contentsOf: contribution.weights)
                }
            }
            
            elements.append(SCNGeometryElement(indices: indices,
                                               primitiveType: .triangles))
        }
        
        var sources = [SCNGeometrySource(vertices: vertices)]
        
        if hasTextureCoordinates {
            
            sources.append(SCNGeometrySource(textureCoordinates: textureCoordinates))
        }
        
        if hasVertexNormals {
            
            sources.append(SCNGeometrySource(normals: normals))
        }
        
        if hasVertexColors {
            
            sources.append(SCNGeometrySource(colors: colors))
        }
        
        let geometry = SCNGeometry(sources: sources,
                                   elements: elements)
        
        self.init(baseGeometry: geometry,
                  bones: bones,
                  boneInverseBindTransforms: boneInverseBindTransforms,
                  boneWeights: SCNGeometrySource(boneWeights: boneWeights),
                  boneIndices: SCNGeometrySource(boneIndices: boneIndices))
    }
}
