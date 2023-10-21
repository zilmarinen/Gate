//
//  AppView.swift
//
//  Created by Zack Brown on 17/10/2023.
//

import Bivouac
import Gate
import SceneKit
import SwiftUI

struct AppView: View {
    
    @ObservedObject private var viewModel = AppViewModel()
    
    var body: some View {
        
        #if os(iOS)
            NavigationStack {
        
                viewer
            }
        #else
            viewer
        #endif
    }
    
    var viewer: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            sceneView
            
            Text("Polygons: [\(viewModel.profile.polygonCount)] Vertices: [\(viewModel.profile.vertexCount)]")
                .foregroundColor(.black)
                .padding()
        }
    }
    
    var sceneView: some View {
        
        SceneView(scene: viewModel.scene,
                  pointOfView: viewModel.scene.camera.pov,
                  options: [.allowsCameraControl,
                            .autoenablesDefaultLighting])
        .toolbar {
            
            ToolbarItemGroup {
                
                toolbar
            }
        }
    }
    
    @ViewBuilder
    var toolbar: some View {
        
        Picker("Build",
               selection: $viewModel.build) {
                    
            ForEach(Skeleton.Build.allCases, id: \.self) { build in
                        
                    Text(build.id)
                            .id(build)
                }
            }
        
        Menu {
                                
            Toggle("Show Bones", isOn: $viewModel.showBones)
            Toggle("Show Joints", isOn: $viewModel.showJoints)
            Toggle("Show Mesh", isOn: $viewModel.showMesh)
            
        } label: {
            
            Label("Change viewer settings", systemImage: "slider.horizontal.3")
        }
    }
}
