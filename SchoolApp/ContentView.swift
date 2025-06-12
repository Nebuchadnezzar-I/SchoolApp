//
//  ContentView.swift
//  SchoolApp
//
//  Created by Michal Ukropec on 12/06/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            VStack {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}
