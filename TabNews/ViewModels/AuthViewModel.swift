//
//  AuthViewModel.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 02/12/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var email = ""
    @Published var password = ""
    
    private let authService = AuthService.shared
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        isAuthenticated = authService.isLoggedIn()
    }
    
    func login() async {
        // Validações básicas
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor, preencha todos os campos"
            return
        }
        
        guard email.contains("@") else {
            errorMessage = "Por favor, insira um email válido"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await authService.login(email: email, password: password)
            isAuthenticated = true
            // Limpa os campos após login bem-sucedido
            email = ""
            password = ""
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() {
        authService.logout()
        isAuthenticated = false
        errorMessage = nil
    }
}
