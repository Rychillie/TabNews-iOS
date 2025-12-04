//
//  HomeViewModel.swift
//  TabNews
//
//  Created by Danilo Lira on 04/12/25.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var contents: [ContentResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let contentService = ContentService.shared
    private let isoFormatter = ISO8601DateFormatter()
    private let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.unitsStyle = .full
        return formatter
    }()

    func loadContents() async {
        defer { isLoading = false }
        isLoading = true
        errorMessage = nil
        
        do {
            contents = try await contentService.fetchContents()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func relativePublishedAt(for content: ContentResponse) -> String {
        guard let date = isoFormatter.date(from: content.publishedAt) else {
            return ""
        }
        
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
}
