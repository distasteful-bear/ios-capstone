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
        return [NSSortDescriptor(key:"price", ascending:false)]
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

func clearDatabase(dishes: [Dish]) {
        let range = dishes.count - 1
        for count in 0...range {
            // find this book in our fetch request
            let dish = dishes[count]
            
            // delete it from the context
            persistence.container.viewContext.delete(dish)
            
        }
        
        // save the context
        try? persistence.container.viewContext.save()
        print ("Attempted to clear Database.")
}



var searchOn: Bool = false
var filter: String = "A-Z"
var searchTerm: String = "10"

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var refresh: Bool = false
    
    func update() {
       refresh.toggle()
        print ("Updated screen.")
    }
    
    func getMenuData() {
        if (hasLoadedMenu) {
            clearDatabase(dishes: Array(dishes))
        }
        
        let dataAddress: String =
        "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        
        let url = URL(string: dataAddress)
        let request = URLRequest(url: url!)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let string = String(data: data, encoding: .utf8) {
                JSONraw = string
            }
            let jsonData = JSONraw.data(using: .utf8)
            
            if let menu = try? JSONDecoder().decode(MenuList.self, from: jsonData!) {
                for itemSelection in menu.menu {
                    let Selection =  Dish(context: viewContext)
                    Selection.title = itemSelection.title
                    Selection.image = itemSelection.image
                    Selection.price = itemSelection.price
                }
                try? persistence.container.viewContext.save()
            }
        }
        dataTask.resume()
        hasLoadedMenu = true
        update()
        print("dataTask has run.")
    }
    
    
    @FetchRequest(sortDescriptors: fetchController(searchOn: searchOn, filter: filter, searchTerm: searchTerm),
                    predicate: predicateController(searchOn: searchOn, searchTerm: searchTerm))
                  var dishes: FetchedResults<Dish>
    
    func filterAcending ()->Void {
        filter = "A=Z"
        print ("sort type changed to A-Z")
        getMenuData()
    }
    
    func filterNotAcending () -> Void {
        filter = "Z-A"
        print ("sort type changed to Z-A")
        getMenuData()
    }
    
    
    var body: some View {
        
        VStack {
            Text("Little Lemon")
            Text("Chicago")
            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
            
            HStack {
                Button("A-Z", action: filterAcending)
                Button("Z-A", action: filterNotAcending)
            }
            
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
