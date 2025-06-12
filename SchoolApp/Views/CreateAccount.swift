//
//  CreateAccount.swift
//  SchoolApp
//
//  Created by Michal Ukropec on 12/06/2025.
//

import CryptoKit
import SwiftData
import SwiftUI

struct CreateAccount: View {
    @Environment(\.modelContext) private var modelContext
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var accountCreated = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                VStack(spacing: 16) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))

                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .bold()
                            .multilineTextAlignment(.center)
                    }

                    Button("Register") {
                        register()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .padding()
                .navigationDestination(isPresented: $accountCreated) {
                    LoginView()
                }
                .navigationTitle("Create Account")

                Spacer()

                NavigationLink(destination: LoginView()) {
                    Text("Back to Login")
                        .font(.callout)
                        .foregroundColor(.blue)
                }
            }
        }
        .hideKeyboardOnTap()
    }

    func register() {
        errorMessage = nil

        // Validate inputs
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty,
            !confirmPassword.isEmpty
        else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard isValidEmail(email) else {
            errorMessage = "Invalid email format."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        do {
            let allUsers = try modelContext.fetch(FetchDescriptor<UserModel>())

            if allUsers.contains(where: { $0.username == username }) {
                errorMessage = "Username is already taken."
                return
            }

            if allUsers.contains(where: { $0.email == email }) {
                errorMessage = "Email is already used."
                return
            }

            // Insert new user
            let newUser = UserModel(
                username: username,
                hashedPassword: hash(password),
                email: email
            )

            modelContext.insert(newUser)
            try modelContext.save()
            accountCreated = true

        } catch {
            errorMessage =
                "Error creating account: \(error.localizedDescription)"
        }
    }

    func hash(_ str: String) -> String {
        let inputData = Data(str.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    func isValidEmail(_ email: String) -> Bool {
        let regex = #".+@.+\..{2,3}"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
}

#Preview {
    CreateAccount()
        .modelContainer(for: UserModel.self, inMemory: true)
}
