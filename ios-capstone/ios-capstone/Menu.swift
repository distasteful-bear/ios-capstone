//
//  Menu.swift
//  ios-capstone
//
//  Created by James Metz on 1/29/23.
//

import Foundation
import SwiftUI

var JSONraw =  ""

struct Menu: View {
    func getMenuData() {
        
        let dataAddress: String =
            "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        
        let url = URL(string: dataAddress)
        let request = URLRequest(url: url!)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let string = String(data: data, encoding: .utf8) {
                    print(string)
                    JSONraw = string
                }
            let jsonData = JSONraw.data(using: .utf8)
            let menu = try! JSONDecoder().decode(MenuList.self, from: jsonData!)
            print (menu)
            print (menu.menu[1].title)
            
        }
        dataTask.resume()
        
        // parse JSON here.
        
    }
    
    
    var body: some View {
        VStack {
            Text("Little Lemon")
            Text("Chicago")
            Text("Insert Descrition for Restaurant.")
            List {
                // Menu Items.
            }
        } .onAppear {getMenuData()}
    }
}
