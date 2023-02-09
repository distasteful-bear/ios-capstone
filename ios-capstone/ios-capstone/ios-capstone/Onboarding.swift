//
//  Onboarding.swift
//  ios-capstone
//
//  Created by James Metz on 1/29/23.
//

import Foundation
import SwiftUI


// keys for accessing account info from user defaults.
var kFirstName = "first name key"
var kLastName = "last name key"
var kEmail = "email key"
let kIsLoggedIn = "kIsLoggedIn"


struct Onboarding: View {
    
    // stores current versions of account details for permament storage after submission.
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State private var showAlert = false
    @State var isLoggedIn = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                // pushes the user to homepage when they have previously logged in.
                NavigationLink(destination: HomeScreen(), isActive: $isLoggedIn){
                    EmptyView()
                } // this format of navigation link, using destination and isActive has been depricated for iOS 16.
                
                
                // header
                VStack {
                    Image("Little Lemon logo - Standard")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 60, alignment: .top)
                    Divider()
                }.background(styleWhite)
                
                
                // form
                ScrollView {
                    VStack {
                        Text("Create Account:").font(.title3).foregroundColor(styleBlack).bold().padding(.top, 50)
                        ZStack {
                            TextField("First Name", text: $firstName)
                                .padding(.horizontal, 10)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(styleBlack, lineWidth: 2)
                        }
                        .frame(width: 290, height: 30)
                        
                        ZStack {
                            TextField("Last Name", text: $lastName)
                                .padding(.horizontal, 10)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(styleBlack, lineWidth: 2)
                        }
                        .frame(width: 290, height: 30)
                        
                        ZStack {
                            TextField("Email", text: $email)
                                .padding(.horizontal, 10)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(styleBlack, lineWidth: 2)
                        }
                        .frame(width: 290, height: 30)
                    }
                    .frame(width: 300)
                }
                
                
                // login button
                Button {
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
                } label: {Text("Login").padding(.horizontal, 80).bold()}
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .alert(isPresented: $showAlert) {
                        Alert (
                            title: Text("Error Submitting Form"),
                            message: Text("Make sure all required fields have been completed.")
                        )
                    }.tint(Color(#colorLiteral(red: 0.286, green: 0.369, blue: 0.341, alpha: 1)))
                
                Spacer()
            
                // triggers alert when incorrect or incomplete data is submitted.
            }.onAppear {
                if (UserDefaults.standard.bool(forKey: kIsLoggedIn)) {
                    isLoggedIn = true
                }
            }
        }
    }
}
