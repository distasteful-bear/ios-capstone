//
//  Menu.swift
//  ios-capstone
//
//  Created by James Metz on 1/29/23.
//

import Foundation
import SwiftUI

struct Menu: View {
    
    var body: some View {
        VStack {
            Text("Little Lemon")
            Text("Chicago")
            Text("Insert Descrition for Restaurant.")
            List {
                // Menu Items.
            }.navigationBarBackButtonHidden(true)
        }
    }
}
