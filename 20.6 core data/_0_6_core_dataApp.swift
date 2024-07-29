//
//  _0_6_core_dataApp.swift
//  20.6 core data
//
//  Created by Дмитрий Богданов on 14.07.2024.
//

import SwiftUI
@main
struct _0_6_core_dataApp: App {
    let pController = PersistenceController.shared
//    let pController = PersistenceController.preview
    
    var body: some Scene {
        @Environment(\.scenePhase) var scenePhase
        
        WindowGroup {
            ContentView().environment(\.managedObjectContext, pController.container.viewContext)
//                .onChange(of: scenePhase) {
//                    pController.save()
//                }
        }
    }
    
}


