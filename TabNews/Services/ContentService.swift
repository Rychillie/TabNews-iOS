//
//  ContentService.swift
//  TabNews
//
//  Created by Danilo Lira on 04/12/25.
//

import Foundation

final class ContentService {
    static let shared = ContentService()
    private let apiService = APIService.shared
    
    private init() {}
    
    func fetchContents() async throws -> [ContentResponse] {
        try await apiService.request(endpoint: "/contents")
    }
}
