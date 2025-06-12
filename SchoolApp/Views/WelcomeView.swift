//
//  WelcomeView.swift
//  SchoolApp
//
//  Created by Michal Ukropec on 12/06/2025.
//

import SwiftUI

struct WelcomeView: View {
    var user: UserModel

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                NavigationLink("Change Password") {
                    ChangePassword(user: user)
                }
                .navigationTitle("Welcome \(user.username)")

                Spacer()
            }
            .padding()
        }
    }
}
