//
//  PostDetailViewModel.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 08/12/25.
//

import Foundation
import Combine

@MainActor
final class PostDetailViewModel: ObservableObject {
    @Published var content: ContentResponse?
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
    
    func loadContent(username: String, slug: String) async {
        guard !isLoading else { return }
        
        print("🔍 [PostDetailViewModel] Iniciando carregamento - username: \(username), slug: \(slug)")
        
        isLoading = true
        errorMessage = nil
        content = nil
        
        do {
            let fetchedContent = try await contentService.fetchContent(username: username, slug: slug)
            print("✅ [PostDetailViewModel] Conteúdo carregado com sucesso!")
            print("📄 [PostDetailViewModel] Título: \(fetchedContent.title)")
            print("📝 [PostDetailViewModel] Body existe: \(fetchedContent.body != nil)")
            if let body = fetchedContent.body {
                print("📏 [PostDetailViewModel] Tamanho do body: \(body.count) caracteres")
            }
            content = fetchedContent
        } catch {
            print("❌ [PostDetailViewModel] Erro ao carregar: \(error.localizedDescription)")
            errorMessage = "Erro ao carregar conteúdo: \(error.localizedDescription)"
        }
        
        isLoading = false
        print("🏁 [PostDetailViewModel] Carregamento finalizado - isLoading: \(isLoading), hasContent: \(content != nil), hasError: \(errorMessage != nil)")
    }
    
    func relativePublishedAt(for content: ContentResponse) -> String {
        guard let date = isoFormatter.date(from: content.publishedAt) else {
            return ""
        }
        
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
}
