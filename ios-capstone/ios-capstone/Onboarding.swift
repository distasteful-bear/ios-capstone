//
//  Onboarding.swift
//  ios-capstone
//
//  Created by James Metz on 1/29/23.
//

import Foundation
import SwiftUI


var kFirstName = "first name key"
var kLastName = "last name key"
var kEmail = "email key"
let kIsLoggedIn = "kIsLoggedIn"

struct Onboarding: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State private var showAlert = false
    @State var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: HomeScreen(), isActive: $isLoggedIn){
                    EmptyView()
                }
                TextField(
                    "First Name",
                    text: $firstName
                )
                
                TextField(
                    "Last Name",
                    text: $lastName
                )
                
                TextField(
                    "Email",
                    text: $email
                )
                Button ("Register") {
                    if (firstName.isEmpty) {
                        showAlert = true
                    } else if (lastName.isEmpty) {
                        showAlert = true
                    } else if (email.isEmpty) {
                        showAlert = true
                    } else {
                        UserDefaults.standard.set(firstName, forKey: kFirstName)
                        UserDefaults.standard.set(lastName, forKey: kLastName)
                        UserDefaults.standard.set(email, forKey: kEmail)
                        
                        print("form submitted successfully.")
                        
                        isLoggedIn = true
                        UserDefaults.standard.set(isLoggedIn, forKey: kIsLoggedIn)
                    }
                    
                } .alert(isPresented: $showAlert) {
                    Alert (
                        title: Text("Error Submitting Form"),
                        message: Text("Make sure all required fields have been completed.")
                    )
                }
            }.onAppear {
                if (UserDefaults.standard.bool(forKey: kIsLoggedIn)) {
                    isLoggedIn = true
                }
            }
        }
    }
}
