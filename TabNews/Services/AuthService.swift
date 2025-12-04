//
//  AuthService.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 02/12/25.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

class AuthService {
    static let shared = AuthService()
    private let apiService = APIService.shared
    
    private init() {}
    
    func login(email: String, password: String) async throws -> SessionResponse {
        let loginRequest = LoginRequest(email: email, password: password)
        let jsonData = try JSONEncoder().encode(loginRequest)
        
        let response: SessionResponse = try await apiService.request(
            endpoint: "/sessions",
            method: "POST",
            body: jsonData
        )
        
        saveSession(response)
        
        return response
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "session_token")
        UserDefaults.standard.removeObject(forKey: "session_id")
        UserDefaults.standard.removeObject(forKey: "session_expires_at")
    }
    
    func isLoggedIn() -> Bool {
        guard let token = UserDefaults.standard.string(forKey: "session_token"),
              let expiresAtString = UserDefaults.standard.string(forKey: "session_expires_at") else {
            return false
        }
        
        let dateFormatter = ISO8601DateFormatter()
        if let expiresAt = dateFormatter.date(from: expiresAtString) {
            return Date() < expiresAt
        }
        
        return !token.isEmpty
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "session_token")
    }
    
    private func saveSession(_ session: SessionResponse) {
        UserDefaults.standard.set(session.token, forKey: "session_token")
        UserDefaults.standard.set(session.id, forKey: "session_id")
        UserDefaults.standard.set(session.expiresAt, forKey: "session_expires_at")
    }
}
