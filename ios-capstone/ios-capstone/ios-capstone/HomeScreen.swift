//
//  HomeScreen.swift
//  ios-capstone
//
//  Created by James Metz on 1/29/23.
//

import Foundation
import SwiftUI

let persistence = PersistenceController().self
struct HomeScreen: View {
    
    var body: some View {
        TabView {
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem {
                    Label ("Menu", systemImage: "list.dash")
                }
            UserProfile()
                .tabItem {
                    Label ("Profile", systemImage: "square.and.pencil")
            }
        }.navigationBarBackButtonHidden(true)
    }
}
