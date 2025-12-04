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
    @Published private(set) var hasMorePages = true
    @Published private(set) var isLoadingNextPage = false
    @Published private(set) var isRefreshing = false
    
    private let contentService = ContentService.shared
    private let isoFormatter = ISO8601DateFormatter()
    private let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.unitsStyle = .full
        return formatter
    }()
    
    private var currentPage = 1
    private let perPage = 20
    private let strategy = "relevant"
    
    func loadContents(reset: Bool = false) async {
        if isLoading || isLoadingNextPage { return }
        
        if reset {
            currentPage = 1
            hasMorePages = true
            contents = []
            isRefreshing = true
        }
        
        isLoading = currentPage == 1
        isLoadingNextPage = currentPage > 1
        errorMessage = nil
        
        do {
            let newContents = try await contentService.fetchContents(
                page: currentPage,
                perPage: perPage,
                strategy: strategy
            )
            
            filterContent(newContents: newContents)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        isLoadingNextPage = false
        isRefreshing = false
    }
    
    func loadNextPageIfNeeded(currentItem: ContentResponse?) async {
        guard let currentItem else { return }
        
        let thresholdIndex = contents.index(contents.endIndex, offsetBy: -3, limitedBy: contents.startIndex) ?? contents.startIndex
        if let index = contents.firstIndex(where: { $0.id == currentItem.id }), index >= thresholdIndex {
            await loadContents()
        }
    }
    
    func relativePublishedAt(for content: ContentResponse) -> String {
        guard let date = isoFormatter.date(from: content.publishedAt) else {
            return ""
        }
        
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
}

private extension HomeViewModel {
    func filterContent(newContents: [ContentResponse]) {
        let existingIds = Set(contents.map { $0.id })
        let uniqueContents = newContents.filter { !existingIds.contains($0.id) }
        contents.append(contentsOf: uniqueContents)
        hasMorePages = !newContents.isEmpty && newContents.count == perPage
        
        if !newContents.isEmpty {
            currentPage += 1
        }
    }
}
