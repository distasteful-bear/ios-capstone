//
//  ios_capstoneApp.swift
//  ios-capstone
//
//  Created by James Metz on 1/27/23.
//

import SwiftUI

@main
struct ios_capstoneApp: App {
    // let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Onboarding()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
