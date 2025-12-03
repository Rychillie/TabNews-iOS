//
//  APIService.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 02/12/25.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case serverError(String)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Resposta inválida do servidor"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        case .serverError(let message):
            return message
        case .decodingError(let error):
            return "Erro ao processar dados: \(error.localizedDescription)"
        }
    }
}

class APIService {
    static let shared = APIService()
    private let baseURL = "https://www.tabnews.com.br/api/v1"
    
    private init() {}
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Se o status code não for 2xx, tenta decodificar erro
            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    throw APIError.serverError(errorResponse.message)
                } else {
                    throw APIError.serverError("Erro ao comunicar com o servidor (código \(httpResponse.statusCode))")
                }
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
