//
//  MenuItem.swift
//  ios-capstone
//
//  Created by James Metz on 1/29/23.
//

import Foundation


struct MenuItem: Decodable {
    var id: Int = 0
    var title: String = ""
    var description: String = ""
    var price: String = ""
    var image: String = ""
    var category: String = ""
    // there seems to be more possible parameters.
    // keep in mind you might need to come bakc here later before product is released.
}
