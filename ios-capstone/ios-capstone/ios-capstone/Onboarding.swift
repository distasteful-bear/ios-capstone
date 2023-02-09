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
                
                // header
                VStack {
                    Image("Little Lemon logo - Standard")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 60, alignment: .top)
                Divider()
                }.background(styleWhite)
                

                
                
                // welcome tag this kinda looks trash? idk decent idea but execution is trash
                /*
                VStack {
                    Text("Welcome!")
                        .bold()
                        .font(.title)
                        .frame(width: 350, alignment: .topLeading)
                        .padding(.vertical, 30)
                        .padding(.horizontal, 100)
                        .foregroundColor(styleYellow)
                }.background(styleGreen).frame(height: 100)
                */
                 
                
                // form
                ScrollView {
                    VStack {
                        
                        Text("Create Account:").font(.title3).foregroundColor(styleBlack).bold().padding(.top, 50)
                        ZStack {
                            TextField(
                                "First Name",
                                text: $firstName
                            ).padding(.horizontal, 10)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(styleBlack, lineWidth: 3)
                        }.frame(width: 290, height: 30)
                        ZStack {
                            TextField(
                                "Last Name",
                                text: $lastName
                            ).padding(.horizontal, 10)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(styleBlack, lineWidth: 3)
                        }.frame(width: 290, height: 30)
                        ZStack {
                            TextField(
                                "Email",
                                text: $email
                            ).padding(.horizontal, 10)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(styleBlack, lineWidth: 3)
                        }.frame(width: 290, height: 30)
                    }.frame(width: 300)
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
                
            
            }.onAppear {
                if (UserDefaults.standard.bool(forKey: kIsLoggedIn)) {
                    isLoggedIn = true
                }
            }
        }
    }
}
