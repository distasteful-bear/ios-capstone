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


// allows for a search term while fetching results.
func fetchController(searchOn: Bool, filter: String, searchTerm: String)-> [NSSortDescriptor] {
    if searchOn {
        return [NSSortDescriptor(key:"title", ascending: true)]
    }
    else {
        return findSortDescriptors(filterStyle: filter)
    }
}


// allows for sorting results be any of the following cases
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


// allows for either a title search or a price search.
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

// clears database so duplicate instances of the same items won't be created.
func clearDatabase(dishes: [Dish]) {
        let range = dishes.count - 1
        for count in 0...range {
            let dish = dishes[count]
            persistence.container.viewContext.delete(dish)
        }
        try? persistence.container.viewContext.save()
        print ("Attempted to clear Database.")
}


// stores preferences for search
var searchOn: Bool = false
var filter: String = "A-Z"
var searchTerm: String = "10"



struct Menu: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @State var refresh: Bool = false
    @State var searchTermy: String = ""
    
    // reloads screen.
    func update() {
       refresh.toggle()
        print ("Updated screen.")
    }
    
    // pulls data from URL request and stores it into local persistent storage.
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
    
    
    // this fetch request is built for pulling in search options and sort options, I havent had the time to fully
    // implement this functionality but the frame work is here incase I decide to revisit this project.
    @FetchRequest(sortDescriptors: fetchController(searchOn: searchOn, filter: filter, searchTerm: searchTerm),
                    predicate: predicateController(searchOn: searchOn, searchTerm: searchTerm))
                  var dishes: FetchedResults<Dish>
    
    var body: some View {
        
        VStack {
            
            // header
            HStack {
                Image("Little Lemon logo - Standard")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 60, alignment: .top)
                Image("Profile Example")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 60)
            }.background(styleWhite)
            
            // Hero Title thing
            VStack {
                VStack {
                    HStack {
                        VStack {
                            Text("Little Lemon").font(.largeTitle).foregroundColor(styleYellow).frame(width: 200, alignment: .leading)
                            Text("Chicago").font(.title2).foregroundColor(styleWhite).frame(width: 100, alignment: .leading)
                        }
                        Image("Stock Image").resizable().aspectRatio(contentMode: .fit).frame(width: 150, height: 75, alignment: .trailing)
                    }
                    Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                        .font(.body).foregroundColor(styleWhite)
                        .padding(.vertical, 5)
                }.frame(width: 300, height: 250)
                
                // search bar
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(styleBlack, lineWidth: 7)
                        .frame(width: 270, height: 45)
                        .background(styleGrey)
                    HStack {
                        Image(systemName: "magnifyingglass").resizable().aspectRatio(contentMode: .fit)
                        TextField("Search", text: $searchTermy)
                    }.frame(width: 250, height: 25)
                }
            }
            .frame(width: 400, height: 330).background(styleGreen)
            
            
            // displays fetched results from local storage.
            List (dishes) {dish in
                HStack {
                    VStack {
                        Text(dish.title ?? "Unknown title").frame(width: 150,alignment: .leading).font(.title3)
                        Text("$" + (dish.price ?? "Unknown Price")).frame(width: 150, alignment: .leading).font(.body)
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
                }
                .frame(width: 300, alignment: .center)
            }
            // reloads data when it hasnt already. also allows for update() to trigger pulling again with new search terms if changed. 
        } .onAppear {if (!hasLoadedMenu) {getMenuData()}}
    }
}
