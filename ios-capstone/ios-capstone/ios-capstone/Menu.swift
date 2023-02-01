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
 
func fetchController(searchOn: Bool, filter: String, searchTerm: String)-> [NSSortDescriptor] {
    if searchOn {
        return [NSSortDescriptor(key:"title", ascending: true)]
    }
    else {
        return findSortDescriptors(filterStyle: filter)
    }
}

func findSortDescriptors(filterStyle: String)-> [NSSortDescriptor] {
    switch filterStyle {
    case "A-Z":
        return [NSSortDescriptor(key:"title", ascending: true)]
    case "Z-A":
        return [NSSortDescriptor(key:"title", ascending: false)]
    case "$-$$$":
        return [NSSortDescriptor(key:"price", ascending:true)]
    case "$$$-$":
        return [NSSortDescriptor(key:"price", ascending:true)]
    default:
        return [NSSortDescriptor(key:"title", ascending: true)]
    }
}

func findSearchDescriptors(search: String)-> [NSSortDescriptor] {
    return [NSSortDescriptor()]
}

func predicateController(searchOn: Bool, searchTerm: String)-> NSPredicate {
    if searchOn {
        let result = NSPredicate(format: "title CONTAINS[cd] %@", searchTerm)
        return result
    }
    else {
        let result = NSPredicate(format: "price CONTAINS[cd] %@", "10")
        return result
    }
}





var searchOn: Bool = false
var filter: String = "A-Z"
var searchTerm: String = "10"

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
    
    // this was the first shot at sorting capacity, didnt go so hot haha, ill try again below.
    /*
    func refineResults(sort: String)-> FetchedResults<Dish> {
        if searchOn {
            @FetchRequest(
                sortDescriptors: [NSSortDescriptor(keyPath: \Dish.title,
                                                   ascending: true)],
                predicate: NSPredicate(format: "title CONTAINS[cd] %@", sort),
                animation: .default) var dishes: FetchedResults<Dish>
        }
        else {
            switch sort {
            case "$-$$$":
                @FetchRequest(
                    sortDescriptors: [NSSortDescriptor(keyPath: \Dish.price,
                    ascending: true)],
                    animation: .default)  var dishes: FetchedResults<Dish>
            case "A-Z":
                @FetchRequest(
                    sortDescriptors: [NSSortDescriptor(keyPath: \Dish.title,
                    ascending: true)],
                    animation: .default)  var dishes: FetchedResults<Dish>
            case "$$$-$":
                @FetchRequest(
                    sortDescriptors: [NSSortDescriptor(keyPath: \Dish.price,
                    ascending: false)],
                    animation: .default)  var dishes: FetchedResults<Dish>
            case "Z-A":
                @FetchRequest(
                    sortDescriptors: [NSSortDescriptor(keyPath: \Dish.title,
                    ascending: false)],
                    animation: .default)  var dishes: FetchedResults<Dish>
            default:
                @FetchRequest(
                    sortDescriptors: [NSSortDescriptor(keyPath: \Dish.title,
                    ascending: true)],
                    animation: .default)  var dishes: FetchedResults<Dish>
            }
        }
    }
    */
    
    
    
    
    
    
// predicate: predicateController(searchOn: searchOn, searchTerm: searchTerm)
    @FetchRequest(sortDescriptors: fetchController(searchOn: searchOn, filter: filter, searchTerm: searchTerm),
                    predicate: predicateController(searchOn: searchOn, searchTerm: searchTerm))
                  var dishes: FetchedResults<Dish>
    
    
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
        } .onAppear {if (!hasLoadedMenu) {getMenuData()}
            
        } // make sure when sorting buttons are pressed they change has loaded to false and reload from scratch the view.
    }
}
