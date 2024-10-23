//
//  Skin.swift
//
//  Created by Zack Brown on 07/08/2024.
//

import Bivouac
import Euclid
import Foundation

internal class Skin {
    
    internal let skeleton: Skeleton
    
    required init(_ skeleton: Skeleton) {
        
        self.skeleton = skeleton
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Skin {
    
    internal var mesh: Mesh {
        
        do {
            
            let mesh = try head().union(torso().union(legs()))
            let mirror = mesh.reflect(along: .yz)
            
            return mesh.merge(mirror)
        }
        catch { fatalError(error.localizedDescription) }
    }
    
    internal func head() throws -> Mesh {
        return Mesh([])
//        let headHeight = skeleton.headHeight
//        let size = Vector(headHeight / 1.5,
//                          headHeight,
//                          headHeight / 2.0)
//        
//        return try Mesh.head(size).translated(by: skeleton.position(.neckEffector))
    }
    
    internal func torso() throws -> Mesh {
        return Mesh([])
//        let torsoHeight = skeleton.torsoHeight
//        let armLength = skeleton.armLength
//        
//        let torso = try Mesh.torso(torsoHeight).translated(by: skeleton.position(.chest))
//        
//        return Mesh([])
    }
    
    internal func legs() throws -> Mesh {
        
        let pelvis = Mesh.Pelvis()
        let ankle = Mesh.Ankle()
        let neck = skeleton.position(.collarbone)
        let hip = skeleton.position(.rightHip)
        let heel = skeleton.position(.rightHeel)
        let normal = neck - hip
        let pointOnPlane = hip - Vector(0.0,
                                        Mesh.Constant.hipLength,
                                        0.0)
        
        guard let plane = Plane(normal: normal,
                                pointOnPlane: pointOnPlane) else { throw MeshError.invalidPlane }

        let leg = try Mesh.leg(pelvis,
                               ankle,
                               plane).translated(by: heel)
        let foot = try Mesh.foot(ankle).translated(by: heel)
        
        return leg.union(foot)
    }
}

extension Polygon {
    
    func reflect(along plane: Plane) -> Self {
        
        mapVertices { vertex in
            
            let projected = vertex.position.project(onto: plane)
            
            let distance = vertex.position - projected
            
            return Vertex(projected - distance,
                          vertex.normal,
                          vertex.texcoord,
                          vertex.color)
        }.inverted()
    }
}

extension Mesh {
    
    func reflect(along plane: Plane) -> Self { Self(polygons.map { $0.reflect(along: plane) }) }
}

/*
 
        // create a plane object representing the Plane
         var plane = new Plane(-Plane.forward, Plane.position);

         // get the closest point on the plane for the Source position
         var mirrorPoint = plane.ClosestPointOnPlane(Source.position);

         // get the position of Source relative to the mirrorPoint
         var distance = Source.position - mirrorPoint;

         // Move from the mirrorPoint the same vector but inverted
         transform.position = mirrorPoint - distance;
 
 */
