//
//  LoginView.swift
//  SchoolApp
//
//  Created by Michal Ukropec on 12/06/2025.
//

import CryptoKit
import SwiftData
import SwiftUI

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext1
    @State var email: String = ""
    @State var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn = false
    @State private var loggedInUser: UserModel? = nil

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))

                HStack {
                    Spacer()
                    NavigationLink(destination: ForgotPassword()) {
                        Text("Forgot Password?")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .bold()
                        .multilineTextAlignment(.center)
                }

                Button("Login") {
                    login()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                if let user = loggedInUser {
                    WelcomeView(user: user)
                }
            }
            .navigationTitle("Login")

            Spacer()

            NavigationLink(destination: CreateAccount()) {
                Text("Create Account")
                    .font(.callout)
                    .foregroundColor(.blue)
            }
        }
        .hideKeyboardOnTap()
    }

    func login() {
        errorMessage = nil

        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        do {
            let allUsers = try modelContext1.fetch(FetchDescriptor<UserModel>())

            guard let user = allUsers.first(where: { $0.email == email }) else {
                errorMessage = "Invalid email or password."
                return
            }

            if user.hashedPassword == hash(password) {
                isLoggedIn = true
                loggedInUser = user

                email = ""
                password = ""
            } else {
                errorMessage = "Invalid email or password."
            }

        } catch {
            errorMessage = "Database error: \(error.localizedDescription)"
        }
    }

    func hash(_ str: String) -> String {
        let inputData = Data(str.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

#Preview {
    LoginView()
}
