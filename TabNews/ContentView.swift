//
//  ContentView.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 02/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                HomeView(viewModel: authViewModel)
            } else {
                LoginView(viewModel: authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
