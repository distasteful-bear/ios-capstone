//
//  Menu.swift
//  ios-capstone
//
//  Created by James Metz on 1/29/23.
//

import Foundation
import SwiftUI
import CoreData

var JSONraw =  ""

struct Menu: View {

    @Environment(\.managedObjectContext) private var viewContext
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
                
            if let menu = try? JSONDecoder().decode(MenuList.self, from: jsonData!) {
                print (menu)
                print (menu.menu[1].title)
                for itemSelection in menu.menu {
                    let Selection =  Dish(context: viewContext)
                    Selection.title = itemSelection.title
                    Selection.image = itemSelection.image
                    Selection.price = itemSelection.price
                    print (String(Selection.title ?? "Error pulling Dish Title from Core Data"))
                }
                try? persistence.container.viewContext.save()
            }
        }
        dataTask.resume()
    }
    
    
    
    

    @FetchRequest(sortDescriptors: []) var dishes: FetchedResults<Dish>
    var body: some View {
        
        VStack {
            Text("Little Lemon")
            Text("Chicago")
            Text("Insert Descrition for Restaurant.")
            List (dishes) {dish in
                Text(dish.title ?? "Unknown")
                
            }
        } .onAppear {getMenuData()}
    }
}
