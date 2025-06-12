//
//  Item.swift
//  SchoolApp
//
//  Created by Michal Ukropec on 12/06/2025.
//

import Foundation
import SwiftData

@Model
class UserModel {
    var username: String
    var email: String
    var hashedPassword: String

    init(username: String, hashedPassword: String, email: String) {
        self.username = username
        self.hashedPassword = hashedPassword
        self.email = email
    }
}
