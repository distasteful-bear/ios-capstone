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
var controller = PersistenceController()
var hasLoadedMenu = false

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    func getMenuData() {
        hasLoadedMenu = true
        controller.clear()
        
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
        print("dataTask has run.")
    }
    
    
    
    

    @FetchRequest(sortDescriptors: []) var dishes: FetchedResults<Dish>
    var body: some View {
        
        VStack {
            Text("Little Lemon")
            Text("Chicago")
            Text("Insert Descrition for Restaurant.")
            List (dishes) {dish in
                HStack {
                    VStack {
                        Text(dish.title ?? "Unknown title").frame(alignment: .leading).font(.title3)
                        Text(dish.price ?? "Unknown Price").frame( alignment: .leading).font(.body)
                    }.frame(alignment: .leading)
                    Spacer()
                    AsyncImage(url: URL(string:dish.image ?? "ellipsis")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50, alignment: .trailing)
                    
                }.frame(width: 300, alignment: .center)
            }
        } .onAppear {if (!hasLoadedMenu) {getMenuData()}}
    }
}
