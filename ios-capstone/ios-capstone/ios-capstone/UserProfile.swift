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
        VStack {
            Text ("Personal Information")
            Image("profile-image-placeholder")
            Text(firstNameRef)
            Text(lastNameRef)
            Text(emailRef)
            Button ("Logout") {
                UserDefaults.standard.set(false, forKey: "kIsLoggedIn")
                self.presentation.wrappedValue.dismiss()
            }
            Spacer()
        }
    }
}
