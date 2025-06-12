//
//  ChangePassword.swift
//  SchoolApp
//
//  Created by Michal Ukropec on 12/06/2025.
//

import CryptoKit
import SwiftData
import SwiftUI

struct ChangePassword: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var user: UserModel

    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                VStack(spacing: 16) {
                    SecureField("Old Password", text: $oldPassword)
                        .padding()
                        .background(Color(.systemGray6))

                    SecureField("New Password", text: $newPassword)
                        .padding()
                        .background(Color(.systemGray6))

                    SecureField("Confirm New Password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .bold()
                            .multilineTextAlignment(.center)
                    }

                    if let success = successMessage {
                        Text(success)
                            .foregroundColor(.green)
                            .bold()
                            .multilineTextAlignment(.center)
                    }

                    Button("Change Password") {
                        changePassword()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                }
                .navigationTitle("Change Password")

                Spacer()
            }
            .padding()
            .hideKeyboardOnTap()
        }
    }

    func changePassword() {
        errorMessage = nil
        successMessage = nil

        // Validations
        guard !oldPassword.isEmpty, !newPassword.isEmpty,
            !confirmPassword.isEmpty
        else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard hash(oldPassword) == user.hashedPassword else {
            errorMessage = "Old password is incorrect."
            return
        }

        guard newPassword != oldPassword else {
            errorMessage = "New password must be different from old one."
            return
        }

        guard newPassword.count >= 6 else {
            errorMessage = "New password must be at least 6 characters."
            return
        }

        guard newPassword == confirmPassword else {
            errorMessage = "New passwords do not match."
            return
        }

        // Update and save
        do {
            user.hashedPassword = hash(newPassword)
            try modelContext.save()
            successMessage = "Password changed successfully."
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
        }
    }

    func hash(_ str: String) -> String {
        let inputData = Data(str.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
