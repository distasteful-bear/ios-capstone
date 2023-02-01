//
//  UserProfile.swift
//  ios-capstone
//
//  Created by James Metz on 1/29/23.
//

import Foundation
import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    let firstNameRef: String = UserDefaults.standard.string(forKey: kFirstName) ?? "Name Not Accessible";
    let lastNameRef: String = UserDefaults.standard.string(forKey: kLastName) ?? "Name Not Accessible";
    let emailRef: String = UserDefaults.standard.string(forKey: kEmail) ?? "Email Not Accessible";
    
    
    var body: some View {
        ScrollView {
            
                HStack {
                    Image("externaldrive.trianglebadge.exclamationmark")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 25)
                    Spacer()
                    
                }
            VStack {
                Text ("Personal Information").font(.title2.bold()).frame(width: 300, alignment: .leading)
                Text ("Avatar").font(.body).frame(width: 300, alignment: .leading)
                Image(systemName: "externaldrive.trianglebadge.exclamationmark")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 70, alignment: .topLeading)
                    .padding()
                Text("Name: ").font(.body.bold()).frame(width: 300, alignment: .leading)
                Text(firstNameRef + " " + lastNameRef).frame(width: 300, alignment: .leading)
                    .padding()
                Text("Email: ").font(.body.bold()).frame(width: 300, alignment: .leading)
                    .padding()
                Text(emailRef).frame(width: 300, alignment: .leading)
                    .padding()
                Button {
                    UserDefaults.standard.set(false, forKey: "kIsLoggedIn")
                    self.presentation.wrappedValue.dismiss()
                } label: {
                    Text("Logout")
                        .padding(.horizontal, 30)
                }.buttonStyle(.borderedProminent)
                .frame(width: 200, height: 30)
                .padding()
                .padding()
            }
        }
    }
}
