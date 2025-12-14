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
    
    func fetchContents(
        page: Int,
        perPage: Int,
        strategy: String
    ) async throws -> [ContentResponse] {
        let endpoint = "/contents?page=\(page)&per_page=\(perPage)&strategy=\(strategy)"
        return try await apiService.request(endpoint: endpoint)
    }
    
    func fetchContent(username: String, slug: String) async throws -> ContentResponse {
        let endpoint = "/contents/\(username)/\(slug)"
        return try await apiService.request(endpoint: endpoint)
    }
}
