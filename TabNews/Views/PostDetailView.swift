//
//  PostDetailView.swift
//  TabNews
//
//  Created by Rychillie Umpierre de Oliveira on 08/12/25.
//

import SwiftUI
import MarkdownUI

struct PostDetailView: View {
    let username: String
    let slug: String
    
    @StateObject private var viewModel = PostDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView()
            } else if let error = viewModel.errorMessage {
                errorView(with: error)
            } else if let content = viewModel.content {
                contentView(content: content)
            } else {
                // Estado padrão (não deveria acontecer)
                Text("Aguardando...")
                    .foregroundColor(.secondary)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadContent(username: username, slug: slug)
        }
    }
}

private extension PostDetailView {
    func loadingView() -> some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Carregando...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func errorView(with errorMessage: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.largeTitle)
            Text(errorMessage)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal)
            
            Button("Tentar novamente") {
                Task {
                    await viewModel.loadContent(username: username, slug: slug)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    func contentView(content: ContentResponse) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text(content.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        Label(content.ownerUsername, systemImage: "person.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text(viewModel.relativePublishedAt(for: content))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 16) {
                        Label("\(content.tabcoins)", systemImage: "star.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Label("\(content.childrenDeepCount)", systemImage: "bubble.left.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                Divider()
                    .padding(.horizontal)
                
                // Content Body
                if let body = content.body, !body.isEmpty {
                    Markdown(body)
                        .markdownTheme(.basic)
                        .textSelection(.enabled)
                        .padding(.horizontal)
                } else {
                    Text("Sem conteúdo disponível")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                
                // Source URL if available
                if let sourceURL = content.sourceURL, !sourceURL.isEmpty {
                    Divider()
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fonte")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let url = URL(string: sourceURL) {
                            Link(sourceURL, destination: url)
                                .font(.footnote)
                                .lineLimit(1)
                        } else {
                            Text(sourceURL)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    NavigationView {
        PostDetailView(username: "filipedeschamps", slug: "tentando-construir-um-pedaco-de-internet-mais-massa")
    }
}
