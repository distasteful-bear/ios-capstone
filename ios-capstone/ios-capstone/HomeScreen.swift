//
//  HomeScreen.swift
//  ios-capstone
//
//  Created by James Metz on 1/29/23.
//

import Foundation
import SwiftUI


struct HomeScreen: View {
    
    var body: some View {
        TabView {
            Menu().navigationBarBackButtonHidden(true)
                .tabItem {
                    Label ("Menu", systemImage: "list.dash")
                }
        }
    }
}
