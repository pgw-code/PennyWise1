//
//  PennyWiseApp.swift
//  PennyWise
//
//  Created by Praveen Wadikar on 8/3/24.
//

import SwiftUI

@main
struct PennyWiseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ManualFetchView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}
